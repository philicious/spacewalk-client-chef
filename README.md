spacewalk-client Cookbook
=========================
This cookbook installs and registers a node as a Spacewalk client.

Requirements
------------
- Ubuntu 12.04, 14.04, 16.04
- CentOS/RHEL 5,6,7

Attributes
----------
```
default['spacewalk']['pkg_source_path'] = Chef::Config[:file_cache_path]
default['spacewalk']['rhel']['base_url'] = 'http://yum.spacewalkproject.org/2.6-client/RHEL'
default['spacewalk']['rhel']['repo_version'] = '2.6-0'
default['spacewalk']['reg']['key'] = 'my_activation_key'
default['spacewalk']['reg']['server'] = 'http://spacewalk.example.com'
default['spacewalk']['enable_osad'] = false
default['spacewalk']['enable_rhncfg'] = false
default['spacewalk']['rhncfg']['actions']['run'] = false # systems also need provisioning entitlement
```

Usage
-----
#### spacewalk-client::rhel
Include `spacewalk-client::rhel` in your node's `run_list` and set the default['spacewalk']['reg'] attributes.

#### spacewalk-client::ubuntu

Include `spacewalk-client::ubuntu` in your node's `run_list` and set the default['spacewalk']['reg'] attributes.

Make sure you somehow (cookbook\_file, remote\_file..) put the following files in default['spacewalk']['pkg\_source\_path']
- apt-transport-spacewalk_1.0.6-4.1_all.deb
- python-ethtool_0.11-3_amd64.deb (dont use 0.12-1, causes segfault on xenial)
- python-rhn_2.5.72-1_all.deb
- rhn-client-tools_1.8.26-4_amd64.deb
- rhnsd_5.0.4-3_amd64.deb
- rhncfg_5.10.14-1ubuntu1_all.deb

(if you want OSAD)
- pyjabber_0.5.0-1.4ubuntu3.all.deb
- osad_5.11.27-1ubuntu1.all.deb

these versions are tested to work with Ubuntu trusty and xenial

You can build them yourself like described here
http://www.devops-blog.net/spacewalk/registering-ubuntu-and-debian-servers-with-spacewalk
and the OSAD packages from here
https://launchpad.net/~mj-casalogic/+archive/ubuntu/spacewalk-ubuntu/+packages

License and Authors
-------------------
Authors: Phil Schuler http://devops-blog.net
