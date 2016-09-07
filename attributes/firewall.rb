# Configuration for the (deliberately simple) default firewall

default['ingenerator']['default_firewall']['do_provision'] = not_environment?(:localdev)
default['ingenerator']['default_firewall']['allow_http']   = true
default['ingenerator']['default_firewall']['allow_https']  = true
