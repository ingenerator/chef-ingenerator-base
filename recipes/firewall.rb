#
# Provisions a default SSH / HTTP only firewall on the instance
#
# This is intentionally fairly limited in terms of customisation, to avoid risk
# of messing things up with lots of attributes.
#
# By default, the firewall:
#
#  * is not provisioned if the node_environment = localdev (override this by forcing
#    ingenerator.default_firewall.do_provision to true
#  * allows http and https as well as ssh (disable these by setting either of
#    ingenerator.default_firewall.enable_http(/s) to false
#
# If you need to add additional rules, simply use a recipe in your application cookbook
# to define further `firewall_rule` blocks.
#
# If you want to do your own thing entirely, override ingenerator.default_firewall.do_provision
# to false and this whole recipe will be skipped.

# Default not to install the firewall on local dev boxes
if is_environment?(:localdev)
  node.normal['ingenerator']['default_firewall']['do_provision'] = false
end

# Provision if required
if node['ingenerator']['default_firewall']['do_provision']
  # Access the custom SSH port, throwing if not properly configured
  ssh_port = custom_ssh_port

  # Install the firewall
  include_recipe 'firewall::default'

  firewall_rule 'ssh' do
    command :allow
    logging :packets
    port    ssh_port
  end

  firewall_rule 'http' do
    command   :allow
    only_if   { node['ingenerator']['default_firewall']['allow_http'] }
    port      80
    position  1
    protocol  :tcp
  end

  firewall_rule 'https' do
    command   :allow
    only_if   { node['ingenerator']['default_firewall']['allow_https'] }
    port      443
    position  2
    protocol  :tcp
  end

else
  Chef::Log.warn('ingenerator-base::firewall is not installing default firewall')
end
