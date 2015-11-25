Chef Cookbook - Linux Tweak
==============

This Chef recipe will perform a few tweaks on linux systems, and a few Ubuntu specific tweaks on Ubuntu systems.


Tweaks Performed
------------
1. Added EPEL repos (rhel-based systems only)
2. Remove the following packages;
  1. puppet (Since we are using Chef)
  2. landscape-client-ui (Ubuntu only)
  3. landscape-client-ui-install (Ubuntu only)
  4. landscape-client (Ubuntu only)
  5. landscape-common (Ubuntu only)
  6. apparmor (Ubuntu only)
  7. ufw (Ubuntu only)
3. Install some packages I commonly use
  1. vim
  2. curl (For some reason not always present on base systems)
  3. gnupg2 (I use gpg2 a lot)
  4. atop
  5. bmon (Not on rhel-based systems)
  6. git
  7. bash (FreeBSD 10 has this missing by default)
4. Add some custom bash settings for all users
  1. Add aliases for ls -lh and ls -lhtr
  2. Add an alias to change rm into rm -i
  3. Added an alias so "ssh" becomes "ssh -A"
  4. Added an alias so "root" becomes "ssh -A -lroot"
  5. Change the history so it maintains 5000 entries and have date/time stamps
  6. Export a nice bash PS1
  7. Export vim as the default editor
  8. Delete the .bashrc for root and uids 500-900 (Except on FreeBSD)
  9. Replace the .bashrc and .bash_profile for root (FreeBSD only)

Requirements
------------
1. Chef (Tested on Chef 12)
2. Linux chef-clients (Tested on Ubuntu 14.04, Debian 7.8, CentOS 5.11, CentOS 6.7 and FreeBSD 10 but kitchen will let you test anything you want)
3. The line cookbook from Chef Supermarket
4. The apt cookbook from Chef Supermarket
5. The yum-epel cookbook from Chef Supermarket

Installation Tips
------------

1. I personally use Berks to install this into my Chef server, because it's easier.

Attributes
------------
['linux-tweak']['PS1'] allows you to override my bash prompt preferences with your own. It should contain the entire "export PS1=" line, not just the prompt! 

Limitations
------------
1. This recipe has been tested with Ubuntu 14.04, Ubuntu 15.04, Debian 7.8, CentOS 5.11, CentOS 6.7 and FreeBSD 10 but you can test it with any other Linux distro using kitchen. The full spec test is there.
 1. Well sort of. I didn't spend the effort to escape the bash PS1 for spec testing so it only tests that the bashrc has a PS1 exported.

Bug Fixes & Changes
------------

1. v0.3.2
  1. Added ufw to the list of packages to remove
2. v0.3.1
  1. For FreeBSD servers deploy the root user's bashrc to both .bashrc and .bash_profile so SSH will source it properly
  2. Added aliases for "ssh" and "root"
3. v0.3.0
  1. Adding FreeBSD support
  2. Dropping testing for Ubuntu 12.04. (It may still work, but there are no guarantees)
  3. Changed a few minor things regarding to OS filtering when it comes to deploying certain tweaks.
4. v0.2.9
  1. Kitchen is now using new boxes due to Chef.IO discontinuing some of them
  2. Removed random .DS_Store files that snuck in to a commit
5. v0.2.8
  1. Remove apparmor from Ubuntu systems
  2. Testing against Ubuntu 15.04 has been added
  3. The bash PS1 is now an environment variable
6. v0.2.7
  1. Added dependency on yum-epel from Supermarket for installing git, atop, and bmon from EPEL repo on rhel-based systems
  1. Removed line cookbook version requirement
  2. Remove Puppet if installed since we use Chef (Assists with migrations from Puppet to Chef)
  3. Make sure atop is installed
  4. Make sure bmon is installed on non-rhel systems
  5. Make sure git is installed
7. v0.2.6
  1. Changed the range of UIDs bashrc is customized for to be 500-2000
8. v0.2.5
  1. CentOS users were not sourcing the /etc/bashrc automatically. This was fixed
9. v0.2.4
  1. Alias for l used a pattern match for ll so every time it ran, it would replace ll, and ll would be recreated by its resource. This led to repeating l aliases. This has been fixed.

Use cases
------------
If you like the shell preferences I set (PS1, aliases, etc...) then you can use this module.
