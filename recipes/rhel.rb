arch = node['kernel']['machine'] == 'x86_64' ? 'x86_64' : 'i386'
platform_major = node['platform_version'][0]

remote_file "#{Chef::Config[:file_cache_path]}/spacewalk-client-repo.rpm" do
  source "#{node['spacewalk']['rhel']['base_url']}/#{platform_major}/#{arch}/spacewalk-client-repo-#{node['spacewalk']['rhel']['repo_version']}.el#{platform_major}.noarch.rpm"
  action :create
end

rpm_package 'spacewalk-client-repo' do
  source "#{Chef::Config[:file_cache_path]}/spacewalk-client-repo.rpm"
  action :install
end

include_recipe 'yum-epel'

# base packages
%w(rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin).each do |pkg|
  package pkg do
    action :install
  end
end

# rhn config package
if node['spacewalk']['enable_rhncfg']
  package 'rhncfg-actions' do
    action :install
  end

  if node['spacewalk']['rhncfg']['actions']['run']
    # we need osad for run action to be executed instantly
    node.default['spacewalk']['enable_osad'] = true

    file '/etc/sysconfig/rhn/allowed-actions/script/run' do
      action :create
      owner 'root'
      group 'root'
      mode '0644'
    end
  end
end

# osad package
package 'osad' do
  action :install
  only_if { node['spacewalk']['enable_osad'] }
end

# register client with spacewalk
if node['spacewalk']['enable_osad']
  remote_file '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT' do
    owner 'root'
    group 'root'
    mode '0644'
    source "#{node['spacewalk']['reg']['server']}/pub/RHN-ORG-TRUSTED-SSL-CERT"
  end

  execute 'register-with-spacewalk-server' do
    command "rhnreg_ks --activationkey=#{node['spacewalk']['reg']['key']} --serverUrl=#{node['spacewalk']['reg']['server']}/XMLRPC"
    not_if { (File.exist?('/etc/sysconfig/rhn/systemid')) }
    notifies :restart, 'service[osad]'
  end

  service 'osad' do
    supports status: true, restart: true, reload: true, start: true, stop: true
    action [:start, :enable]
  end
else
  execute 'register-with-spacewalk-server' do
    command "rhnreg_ks --activationkey=#{node['spacewalk']['reg']['key']} --serverUrl=#{node['spacewalk']['reg']['server']}/XMLRPC"
    not_if { (File.exist?('/etc/sysconfig/rhn/systemid')) }
  end
end
