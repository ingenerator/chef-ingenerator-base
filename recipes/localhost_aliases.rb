#
# Adds one or more domain names as aliases for 127.0.0.1 in the hosts file -
# particularly used for allowing build servers to resolve names like 'project.dev'
#
# Author::  Andrew Coulton (<andrew@ingenerator.com>)
# Cookbook Name:: ingenerator-base
# Recipe:: localhost_aliases
#
# Copyright 2012-13, inGenerator Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

active_hosts = []
node['base']['localhost_aliases'].each do |hostname, alias_active|
  active_hosts << hostname if alias_active
end

if active_hosts.empty?
  hostsfile_entry "127.0.0.1" do
    action   :remove
  end
else
  hostsfile_entry "127.0.0.1" do
    hostname active_hosts.shift
    aliases  active_hosts
    action   :create
    comment  'Added by ingenerator-base::localhost_aliases recipe by chef'
  end
end
