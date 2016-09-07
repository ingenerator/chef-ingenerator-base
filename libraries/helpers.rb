module Ingenerator
  module Base
    module Helpers

      # Provides the configured custom SSH port, or throws if it is not configured or not valid
      # This ensures that access to this value is valid everywhere it is used
      def custom_ssh_port
        unless (node['ssh'] && node['ssh']['host_port'])
          raise ArgumentError.new('You must configure an SSH host port in node[\'ssh\'][\'host_port\']')
        end

        unless node['ssh']['host_port'].is_a? Integer
          raise ArgumentError.new('The SSH port configured in node[\'ssh\'][\'host_port\'] must be an integer')
        end


        if is_environment?(:localdev) || is_environment?(:buildslave)
          22
        else
          node['ssh']['host_port']
        end
      end

      # Test if this is the specified environment
      def is_environment?(env)
        node_environment === env.to_sym
      end

      # Test if this is not the specified environment
      def not_environment?(env)
        node_environment != env.to_sym
      end

      # Get the current node environment
      def node_environment
        if node['ingenerator'] && node['ingenerator']['node_environment']
          node['ingenerator']['node_environment'].to_sym
        else
          :production
        end
      end
    end
  end
end

# Make the helpers available in all recipes
Chef::Recipe.send(:include, Ingenerator::Base::Helpers)
Chef::Node.send(:include, Ingenerator::Base::Helpers)
