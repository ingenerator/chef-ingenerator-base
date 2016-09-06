class Chef
  class Recipe

    # Provides the configured custom SSH port, or throws if it is not configured or not valid
    # This ensures that access to this value is valid everywhere it is used
    def custom_ssh_port
      unless (node['ssh'] && node['ssh']['host_port'])
        raise ArgumentError.new('You must configure an SSH host port in node[\'ssh\'][\'host_port\']')
      end

      unless node['ssh']['host_port'].is_a? Integer
        raise ArgumentError.new('The SSH port configured in node[\'ssh\'][\'host_port\'] must be an integer')
      end

      node['ssh']['host_port']
    end
  end
end
