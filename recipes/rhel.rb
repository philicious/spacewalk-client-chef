arch = node['kernel']['machine'] == 'x86_64' ? 'x86_64' : 'i386'
platform_major = node['platform_version'][0]

remote_file "#{Chef::Config[:file_cache_path]}/spacewalk-client-repo.rpm" do
  source "#{node['spacewalk']['rhel']['base_url']}/#{platform_major}/#{arch}/spacewalk-client-repo-2.2-1.el#{platform_major}.noarch.rpm"
  action :create
end

package 'spacewalk-client-repo' do
  source "#{Chef::Config[:file_cache_path]}/spacewalk-client-repo.rpm"
  action :install
end

include_recipe 'yum-epel'

%w(rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'register-with-spacewalk-server' do
  command "rhnreg_ks --activationkey=#{node['spacewalk']['reg']['key']} --serverUrl=#{node['spacewalk']['reg']['server']}/XMLRPC"
  not_if { (File.exist?('/etc/sysconfig/rhn/systemid')) }
end
