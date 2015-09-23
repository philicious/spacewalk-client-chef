name             'spacewalk-client'
maintainer       'Phil Schuler'
maintainer_email 'the.cypher@gmail.com'
license          'GNU GPL v2'
description      'Installs/Configures a Spacewalk client'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.12'

%w(ubuntu redhat centos).each do |os|
  supports os
end

depends 'yum-epel'
