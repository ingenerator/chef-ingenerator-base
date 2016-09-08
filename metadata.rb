name 'ingenerator-base'
maintainer 'Andrew Coulton'
maintainer_email 'andrew@ingenerator.com'
license 'Apache 2.0'
description 'Basic, common, provisioning of all our instances'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.4.0'
issues_url 'https://github.com/ingenerator/chef-ingenerator-base/issues'
source_url 'https://github.com/ingenerator/chef-ingenerator-base'

%w(ubuntu).each do |os|
  supports os
end

depends "apt"
depends 'firewall', '~>2.5'
depends "hostsfile"
depends 'ingenerator-helpers', '~> 1.0'
depends "swap"
depends "timezone-ii"
