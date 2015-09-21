if node['spacewalk']['rhnactions']['run']
  # we need rhncfg + osad for run action
  default['spacewalk']['enable_osad'] = true

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
