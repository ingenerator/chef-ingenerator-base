# Provisions SSH host configuration for remote access
# The configuration template should be as simple as possible for security and to minimise
# any risk of losing access to a server through a misplaced attribute or recipe change

unless (node['ssh'] && node['ssh']['host_port'])
  raise ArgumentError.new('You must configure an SSH host port in node[\'ssh\'][\'host_port\']')
end

unless node['ssh']['host_port'].is_a? Integer
  raise ArgumentError.new('The SSH port configured in node[\'ssh\'][\'host_port\'] must be an integer')
end

template '/etc/ssh/sshd_config' do
  action :create
  owner  'root'
  group  'root'
  mode   0644
  variables({
    :host_port => node['ssh']['host_port'],
  })
  notifies :restart, 'service[ssh]'
end

# Define the SSH service for delayed restart
service "ssh" do
  action :nothing
end
