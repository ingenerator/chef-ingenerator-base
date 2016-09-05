#
# Basic and common instance provisioning
#
# Author::  Andrew Coulton (<andrew@ingenerator.com>)
# Cookbook Name:: ingenerator-base
# Recipe:: default
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

# Note that the apt recipe *must* be first to ensure apt-get update is before any installs
include_recipe "apt"
include_recipe "ingenerator-base::base_packages"
include_recipe "ingenerator-base::localhost_aliases"
include_recipe "timezone-ii::default"
include_recipe "ingenerator-base::swap"

# This will raise an exception if no ssh port has been configured
include_recipe 'ingenerator-base::ssh_host'

# The default chef package installer (on remote hosts) installs the chef-client service - remove it.
service "chef-client" do
  action [:disable,:stop]
end
