package 'install-spacewalk-deps' do
  package_name %w(python-openssl libnl-3-200 libnl-route-3-200 python-dbus
                  python-apt python-newt python-gudev python-dmidecode python-libxml2)
end

%w(python-rhn-2.5.55-2.all.deb
   python-ethtool-0.11-2.amd64.deb
   rhn-client-tools-1.8.26-4.amd64.deb
   apt-transport-spacewalk-1.0.6-2.all.deb
   rhnsd-5.0.4-3.amd64.deb).each do |pkg|
  dpkg_package pkg do
    source "#{node['spacewalk']['pkg_source_path']}/#{pkg}"
  end
end

if node['spacewalk']['enable_osad']
  %w(rhncfg_5.10.14-1ubuntu1.all.deb
     pyjabber_0.5.0-1.4ubuntu3.all.deb
     osad_5.11.27-1ubuntu1.all.deb).each do |pkg|
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
