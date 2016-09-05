inGenerator Base cookbook
=================================
[![Build Status](https://travis-ci.org/ingenerator/chef-ingenerator-base.png?branch=master)](https://travis-ci.org/ingenerator/chef-ingenerator-base)

The `ingenerator-base` cookbook provides chef recipes, attributes and providers for 
provisioning that should be common on all our instances. It may also contain some 
regularly-used recipes etc that do not merit their own cookbooks.

Requirements
------------
- Chef 12.13 or higher
- **Ruby 2.3 or higher**

Installation
------------
We recommend adding to your `Berksfile` and using [Berkshelf](http://berkshelf.com/):

```ruby
cookbook 'ingenerator-base', git: 'git://github.com/ingenerator/chef-ingenerator-base', branch: 'master'
```

Have your main project cookbook *depend* on ingenerator-base by editing the `metadata.rb` for your cookbook.

```ruby
# metadata.rb
depends 'ingenerator-base'
```

Recipes
-------

### Default recipe
The `ingenerator-base::default` recipe will:

* run the "apt::default" recipe to ensure all apt sources are up to date
* install any of the enabled packages from the node['base']['packages'] hash - by default this includes git
* disable and stop the "chef-client" service - we manually run chef-solo when required
* set the system timezone to UTC
* creates a persistent 1G swap file

Attributes
----------

The cookbook provides and is controlled by a number of default attributes:

* [default](attributes/default.rb) - attributes in the `base` group control operation of recipes in this cookbook
* [project](attributes/project.rb) - provide central project configuration - you will generally extend and alter these
  in your roles or app cookbooks.

### Testing
See the [.travis.yml](.travis.yml) file for the current test scripts.

Contributing
------------
1. Fork the project
2. Create a feature branch corresponding to your change
3. Create specs for your change
4. Create your changes
4. Create a Pull Request on github

License & Authors
-----------------
- Author:: Andrew Coulton (andrew@ingenerator.com)

```text
Copyright 2012-2013, inGenerator Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
