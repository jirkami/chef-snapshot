#
# Cookbook Name:: linux-tweak
#
# Copyright 2015, Matthew Ahrenstein, All Rights Reserved.
#
# Maintainers:
# - Matthew Ahrenstein: @ahrenstein
#
# See LICENSE.txt
#

# This attribute determines the default bash PS1 for the bashrc recipe. This allows the flexibility of admins to override this since it's a highly specific preference
default['linux-tweak']['PS1'] = 'export PS1="[\[\e[0;31m\]\u\[\e[0;37m\]@\[\e[0;34m\]\h\[\e[0;37m\]:\[\e[0;32m\]\w\[\e[0m\]]\\$ "'