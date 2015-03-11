spacewalk-client CHANGELOG
==========================

This file is used to list changes made in each version of the spacewalk-client cookbook.

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
