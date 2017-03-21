# base dependencies
%w(python-openssl libnl-3-200 libnl-route-3-200 python-dbus
   python-apt python-newt python-gudev python-dmidecode python-libxml2).each do |pkg|
  package pkg
end

# base packages
%w(python-rhn_2.5.72-1_all.deb
   python-ethtool_0.11-3_amd64.deb
   rhn-client-tools_1.8.26-4_amd64.deb
   apt-transport-spacewalk_1.0.6-4.1_all.deb
   rhnsd_5.0.4-3_amd64.deb).each do |pkg|
  dpkg_package pkg do
    source "#{node['spacewalk']['pkg_source_path']}/#{pkg}"
  end
end

# rhn config package
if node['spacewalk']['enable_rhncfg']
  dpkg_package 'rhncfg_5.10.14-1ubuntu1_all.deb' do
    source "#{node['spacewalk']['pkg_source_path']}/#{name}"
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

    directory '/var/spool/rhn/' do
      owner 'root'
      group 'root'
      mode '0755'
      action :create
    end
  end
end

# osad packages
if node['spacewalk']['enable_osad']
  %w(pyjabber_0.5.0-1.4ubuntu3_all.deb
     osad_5.11.27-1ubuntu1_all.deb).each do |pkg|
    dpkg_package pkg do
      source "#{node['spacewalk']['pkg_source_path']}/#{pkg}"
    end
  end
end

directory '/var/lock/subsys' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

cookbook_file '/etc/apt/apt.conf.d/40fix_spacewalk_pdiff' do
  source '40fix_spacewalk_pdiff'
  owner 'root'
  group 'root'
  mode '0644'
end

# register client with spacewalk
if node['spacewalk']['enable_osad']
  directory '/usr/share/rhn' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

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
