arch = node['kernel']['machine'] == 'x86_64' ? 'x86_64' : 'i386'
platform_major = node['platform_version'][0]

do_register = false

# check if up2date file has correct serverURL value
up2date = '/etc/sysconfig/rhn/up2date'
serverurl_value = "serverURL=#{node['spacewalk']['reg']['server']}/XMLRPC"
if File.exist?(up2date)
  unless IO.read(up2date).include?(serverurl_value)
    Chef::Log.info('Wrong serverURL in up2date file, registering.')
    do_register = true
  end
end

# check if systemid file exists
systemid = '/etc/sysconfig/rhn/systemid'
unless File.exist?(systemid)
  Chef::Log.info('Missing systemid file, registering.')
  do_register = true
end

# if saving key
key_dir = node['spacewalk']['reg']['key_dir']
key_file = "#{key_dir}/key"
if node['spacewalk']['reg']['save']
  directory key_dir do
    recursive true
    owner 'root'
    group 'root'
    mode '600'
    not_if { File.directory? key_dir }
  end
  if !do_register && File.exist?(key_file) && node['spacewalk']['reg']['key'] == IO.read(key_file)
    Chef::Log.info("System has already been registered.")
    return
  end
  file key_file do
    content node['spacewalk']['reg']['key']
    owner 'root'
    group 'root'
    mode '600'
    action :create
  end
  unless do_register
    Chef::Log.info("Missing reg_file or incorrect key_value in reg_file, registering.")
    do_register = true
  end
end

# Keep inventory of existing repos
etc_yum_repos_d = '/etc/yum.repos.d'
original_repos = []
ruby_block 'remove_repo_files' do
  block do
    Dir.foreach(etc_yum_repos_d) do |repo|
      next if repo == '.' or repo == '..'
      original_repos << repo
    end
  end
end

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
    command "rhnreg_ks --activationkey=#{node['spacewalk']['reg']['key']} --serverUrl=#{node['spacewalk']['reg']['server']}/XMLRPC --force"
    notifies :restart, 'service[osad]'
    only_if { do_register }
  end

  service 'osad' do
    supports status: true, restart: true, reload: true, start: true, stop: true
    action [:start, :enable]
  end
else
  execute 'register-with-spacewalk-server' do
    command "rhnreg_ks --activationkey=#{node['spacewalk']['reg']['key']} --serverUrl=#{node['spacewalk']['reg']['server']}/XMLRPC --force"
    only_if { do_register }
  end
end

# remove repos that were added by this recipe
if node['spacewalk']['dont_add_repo_files']
  ruby_block 'remove_repo_files' do
    block do
      Dir.foreach(etc_yum_repos_d) do |repo|
        next if repo == '.' or repo == '..'
        if !original_repos.include? repo
          Chef::Log.info("Removing repo file: #{repo}")
          File.delete("#{etc_yum_repos_d}/#{repo}")
        end
      end
    end
  end
end
