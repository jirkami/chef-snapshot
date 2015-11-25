#
# Cookbook Name:: linux-tweak
# Recipe:: default
#
# Copyright (c) 2015 Ahrenstein, All Rights Reserved.

# Default is just going to call the other recipes in this cookbook where the actual meat of the code is
# We check for the correct OS in the included recipes

# Purge landscape and install vim if needed
include_recipe 'linux-tweak::packages'

# Modify the system-wide bashrc
include_recipe 'linux-tweak::bashrc'
