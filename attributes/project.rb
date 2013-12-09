#
# Attributes for this project - many of these should be overridden in application
# cookbook, and several are used as defaults for other config values
#
# Author:: Andrew Coulton(<andrew@ingenerator.com>)
# Cookbook Name:: ingenerator-base
# Attribute:: project
#
# Copyright 2012-13, Opscode, Inc.
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

# Used for dev hostnames, www checkout paths, loggers, database schemas
default['project']['name'] = 'newproject'

default['project']['contact'] = 'hello@ingenerator.com'