#
# Cookbook Name:: openresty
# Provider:: luarock
#
# Author:: Panagiotis Papadomitsos (<pj@ezgr.net>)
#
# Copyright 2012, Panagiotis Papadomitsos
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'mixlib/shellout'

def luarocks
  "#{node['openresty']['source']['prefix']}/luajit/bin/luarocks"
end

def get_installed_rock_version(rock, version = nil)
  cmd = Mixlib::ShellOut.new("#{luarocks} show #{rock} #{version if version}")
  cmd.run_command
  if (cmd.exitstatus != 0) || (! cmd.exitstatus)
    nil
  else
    cmd.stdout.strip.split("\n").fetch(0).split.fetch(1).split('-').first rescue nil
  end
end

def is_version_installed?(rock, version = nil)
  true && get_installed_rock_version(rock, version)
end

def install_rock(rock, version = nil)
  cmd = Mixlib::ShellOut.new("#{luarocks} install #{rock} #{version if version}")
  cmd.run_command
  if (cmd.exitstatus != 0) || (! cmd.exitstatus)
    Chef::Application.fatal!("Installation of OpenResty LUA rock [#{rock}] #{('version [' + version + ']') if version} failed")
    nil
  else
    true
  end
end

def remove_rock(rock, version = nil)
  cmd = Mixlib::ShellOut.new("#{luarocks} remove #{rock} #{version if version}")
  cmd.run_command
  if (cmd.exitstatus != 0) || (! cmd.exitstatus)
    Chef::Log.fatal("Removal of OpenResty LUA rock [#{rock}] #{('version [' + version + ']') if version} failed")
    nil
  else
    true
  end
end

action :install do
  rock = new_resource.name
  version = new_resource.version rescue nil
  current_version = get_installed_rock_version(rock)
  installed_version = is_version_installed?(rock, version)
  Chef::Log.debug("OpenResty LUA rock [#{rock}] version #{'[' + (version || 'latest') + ']'} scheduled for installation")
  if ((version) && (version != installed_version)) || (! current_version)
    Chef::Log.info("Installing OpenResty LUA rock [#{rock}] #{('version [' + version + ']') if version}")
    install_rock(rock, version)
    new_resource.updated_by_last_action(true)
  else
    new_resource.updated_by_last_action(false)
  end
end

action :remove do
  rock = new_resource.name
  version = new_resource.version rescue nil
  current_version = get_installed_rock_version(rock)
  installed_version = is_version_installed?(rock, version)
  Chef::Log.debug("OpenResty LUA rock [#{rock}] version #{'[' + (version || 'latest') + ']'} scheduled for removal")
  if (current_version) && ((! version) || (version == installed_version))
    Chef::Log.info("Uninstalling OpenResty LUA rock [#{rock}] #{('version [' + version + ']') if version}")
    remove_rock(rock, version)
    new_resource.updated_by_last_action(true)
  else
    new_resource.updated_by_last_action(false)
  end
end
