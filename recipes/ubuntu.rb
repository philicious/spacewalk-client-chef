%w(apt-transport-spacewalk-1.0.6-2.all-deb.deb
   python-ethtool-0.11-2.amd64-deb.deb
   python-rhn-2.5.55-2.all-deb.deb
   rhn-client-tools-1.8.26-3.amd64-deb.deb
   rhnsd-5.0.4-3.amd64-deb.deb).each do |pkg|
  dpkg_package pkg do
    source "#{node['spacewalk']['pkg_source_path']}/#{pkg}"
    ignore_failure true
  end
end

execute 'install-spacewalk-deps' do
  command 'apt-get -yf install'
end

apt_package 'python-libxml2'

directory '/var/lock/subsys' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

cookbook_file '/usr/lib/python2.7/xmlrpclib.py' do
  source 'xmlrpclib.py'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'register-with-spacewalk-server' do
  command "rhnreg_ks --activationkey=#{node['spacewalk']['reg']['key']} --serverUrl=#{node['spacewalk']['reg']['server']}/XMLRPC"
  not_if { (File.exist?('/etc/sysconfig/rhn/systemid')) }
end
