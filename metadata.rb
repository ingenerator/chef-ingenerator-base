name 'ingenerator-base'
maintainer 'Andrew Coulton'
maintainer_email 'andrew@ingenerator.com'
license 'Apache-2.0'
chef_version '>=12.18.31'
description 'Basic, common, provisioning of all our instances'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.6.0'
issues_url 'https://github.com/ingenerator/chef-ingenerator-base/issues'
source_url 'https://github.com/ingenerator/chef-ingenerator-base'

%w(ubuntu).each do |os|
  supports os
end

depends 'apt', '>=6.0'
depends 'firewall', '~>2.5'
depends 'hostsfile', '>=2.4'
depends 'ingenerator-helpers', '~> 1.0'
depends 'swap', '>=2.0'
depends 'timezone_iii', '~> 1.0'
