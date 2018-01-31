spacewalk-client CHANGELOG
==========================

This file is used to list changes made in each version of the spacewalk-client cookbook.

0.2.2
-----
- Added more robust checks for registration (thx Martin Olsen https://github.com/snomann) 

0.2.1
-----
- removed the prebuilt .deb client packages that slipped in

0.2.0
-----
- updated the Ubuntu client package versions
- updated RHEL client repo version to 2.6-0, still was 2.2-1

0.1.12
------
- added client repo version as attribute for ::rhel

0.1.11
------
- added trigger to enable the ability to execute remote scripts

0.1.10
-----
- refactor to be compatible with Chef 11 again due to a bug in Chef, see
  https://github.com/chef/chef/issues/3786 

0.1.9
-----
- install the .debs and dependencies in correct order so we dont need "apt-get -f" afterwards and 
  avoid errors that would need to be ignored

0.1.8
-----
- Added proper support for Ubuntu 14. The available packages from trusty repo are outdated and broken.

0.1.7
-----
- Fixed bug with OSAD being disabled but recipe tried to notify it (PR by https://github.com/obazoud thx!)
- Fixed bug with spacewalk repo rpm not being installed

0.1.6
-----
- Restart osad after registering with Spacewalk

0.1.5
-----
- Install OSAD on clients if default['spacewalk']['enable_osad'] = true . Supports RHEL and Ubuntu
- Changed the .deb package filenames and removed obsolete '-deb'

0.1.4
-----
- Bumped rhn-client-tools package to new version fixing the xmlrpclib.py workaround
- removed obsolete file xmlrpclib.py
- Allow to choose url to download spacewalk package (PR by https://github.com/obazoud thx!)

0.1.3
-----
- Missing file for 0.1.1. 

0.1.1
-----
- Fixed the 'repodata() takes exactly 2 arguments' exception with Ubuntu clients

0.1.0
-----
- [your_name] - Initial release of spacewalk-client

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
