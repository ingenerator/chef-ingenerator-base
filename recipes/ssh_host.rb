# Provisions SSH host configuration for remote access
# The configuration template should be as simple as possible for security and to minimise
# any risk of losing access to a server through a misplaced attribute or recipe change

ssh_port = custom_ssh_port

template '/etc/ssh/sshd_config' do
  action :create
  owner  'root'
  group  'root'
  mode   0644
  variables({
    :host_port => ssh_port,
  })
  notifies :restart, 'service[ssh]'
end

# Define the SSH service for delayed restart
service "ssh" do
  action :nothing
end
