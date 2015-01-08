spacewalk-client Cookbook
=========================
This cookbook installs and registers a node as a Spacewalk client.

Requirements
------------
Ubuntu 12.04, 14.04

Attributes
----------
```
default['spacewalk']['pkg_source_path'] = Chef::Config[:file_cache_path]
default['spacewalk']['reg']['key'] = "my_activation_key"
default['spacewalk']['reg']['server'] = "my_spacewalk_server"
```

Usage
-----
#### spacewalk-client::ubuntu

Just include `spacewalk-client::ubuntu` in your node's `run_list` and set the default['spacewalk']['reg'] attributes.

License and Authors
-------------------
Authors: Phil Schuler http://devops-blog.net

TODO: write spacewalk-client::rhel
