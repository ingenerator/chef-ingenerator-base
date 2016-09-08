#
# Installs the base packages defined in attributes - use for simple packages that do
# not require any configuration.
#
# Author::  Andrew Coulton (<andrew@ingenerator.com>)
# Cookbook Name:: ingenerator-base
# Recipe:: base_packages
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

node['base']['packages'].list_active_keys.each do | package_name |
  package package_name
end
