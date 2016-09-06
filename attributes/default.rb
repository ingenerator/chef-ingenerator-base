#
# Author:: Andrew Coulton(<andrew@ingenerator.com>)
# Cookbook Name:: ingenerator-base
# Attribute:: defaults
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

# System packages that should be installed early in the runlist - generally used for
# simple binaries that require no configuration by chef. Package name is the hash key,
# true/false to configure whether it should be installed.
default['base']['packages']['git'] = true
default['base']['packages']['htop'] = true
default['base']['packages']['ntp'] = true

# Hostnames that should be mapped to localhost via /etc/hosts - see the localhost_aliases recipe
# Provide a hash of hostname => active - true/false
default['base']['localhost_aliases']['localhost'] = true

# Configuration for swap file size and paths
default['swap']['path']    = '/mnt/swap'
default['swap']['size']    = 1024 # Mb
default['swap']['persist'] = true

# Configuration for SSH
# You MUST define a value for this in the application cookbook, otherwise provisioning will fail with
# an exception. The value is always read with the custom_ssh_port helper to ensure it is always validated.
# Note that build slaves and vagrant boxes will always use port 22 regardless of the configuration here
default['ssh']['host_port'] = nil

# Default ingenerator attributes

# Controls default behaviour of most of the ingenerator recipes where we have consistent
# dev / build / production behaviour. Use :localdev, :buildslave or :production in project-level
# role attributes. Usually, recipes that respect this attribute should then default some other
# attribute to disable/enable specific behaviour so that this can then be overridden on a case-by-base
# basis.
default['ingenerator']['node_environment'] = :production
