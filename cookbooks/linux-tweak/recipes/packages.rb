#
# Cookbook Name:: linux-tweak
# Recipe:: packages
#
# Copyright (c) 2015 Ahrenstein, All Rights Reserved.

# This recipe will remove all the Landscape garbage that Canonical thought we would want on our servers.
# It will also make sure vim is present since I set that as the default editor

# Run apt cookbook to refresh apt cache on debian-based systems
case node['platform']
  when 'debian', 'ubuntu'
    include_recipe 'apt' # This allows apt-get update to run before trying to install packages
  else
    # Do nothing
end
# Let's only try to purge Landscape from Ubuntu
case node['platform']
  when 'ubuntu'
    # This creates an array of strings and performs the Chef package functionality of each array entry via a do loop
    %w{apparmor landscape-client-ui landscape-client-ui-install landscape-client landscape-common ufw}.each do |pkg|
      package pkg do
        action :purge
      end
    end
  else
    # Do nothing
end

# Make sure Puppet is removed since we don't use it
package 'puppet' do
  action :purge
end

# This if block checks if the OS is rhel based and sets the rhel vim package name if it is. If not rhel-based then run the apt cookbook and install bmon (Returns as "redhat" in Serverspec code)
case node['platform_family']
  when 'rhel'

    # Make sure EPEL repos exist on rhel-based platforms
    include_recipe 'yum-epel'

    vim_package = 'vim-enhanced'
  # If not we assume the OS is Debian based
  else
    vim_package = 'vim'

    # Install bmon
    package 'bmon' do
      action :install
    end

end

# Make sure vim is present
case node['os']
  when 'linux', 'freebsd'

    package "#{vim_package}" do
      action :install
    end

    # Make sure packages we care about are installed
    %w{bash curl git atop telnet mdadm sysstat}.each do |pkg|
      package pkg do
        action :install
      end
    end

  else
    # Do nothing
end

# FreeBSD doesn't have gnupg2 so we check for Linux here as well
case node['os']
  when 'linux'

    package 'gnupg2' do
      action :install
    end
  else
    # Do nothing
end