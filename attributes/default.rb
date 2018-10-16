default['spacewalk']['pkg_source_path'] = Chef::Config[:file_cache_path]

default['spacewalk']['rhel']['base_url'] = 'http://yum.spacewalkproject.org/2.6-client/RHEL'
default['spacewalk']['rhel']['repo_version'] = '2.6-0'

default['spacewalk']['rhel']['custom_repo']['enabled'] = false
default['spacewalk']['rhel']['custom_repo']['base_url'] ="http://yum.spacewalkproject.org/2.6-client/RHEL/#{node['platform_version'][0]}/$basearch/"
default['spacewalk']['rhel']['custom_repo']['gpg_check'] = true
default['spacewalk']['rhel']['custom_repo']['gpg_key'] = 'http://yum.spacewalkproject.org/RPM-GPG-KEY-spacewalk-2015'

default['spacewalk']['enable_osad'] = false
default['spacewalk']['enable_rhncfg'] = false
default['spacewalk']['rhncfg']['actions']['run'] = false

default['spacewalk']['reg']['key'] = 'my-reg-key'
default['spacewalk']['reg']['server'] = 'http://spacewalk.example.com'
default['spacewalk']['reg']['save'] = false
default['spacewalk']['reg']['key_dir'] = '/root/.spacewalk'

default['spacewalk']['dont_add_repo_files'] = false
