require 'spec_helper'

describe 'ingenerator-base::firewall' do
  context 'when ssh port has not been explicitly configured' do
    let (:chef_run) { ChefSpec::SoloRunner.converge described_recipe }

    it 'raises an exception' do
      expect {
        chef_run
      }.to raise_error(ArgumentError)
    end
  end

  context 'when ssh port is configured' do
    let (:ssh_port) { 2200 }
    let (:chef_run) do
      ChefSpec::SoloRunner.new do | node |
        node.normal['ssh']['host_port'] = ssh_port
      end.converge(described_recipe)
    end

    context 'with default config' do
      it 'installs the firewall using the default recipe' do
        expect(chef_run).to include_recipe('firewall::default')
      end

      it 'allows ssh connections to configured port with logging' do
        expect(chef_run).to create_firewall_rule('ssh').with(
          :command => :allow,
          :logging => :packets,
          :port    => ssh_port
        )
      end

      it 'allows http connections' do
        expect(chef_run).to create_firewall_rule('http').with(
          :command => :allow,
          :logging => nil,
          :port    => 80,
          :position => 1
        )
      end

      it 'allows https connections' do
        expect(chef_run).to create_firewall_rule('https').with(
          :command => :allow,
          :logging => nil,
          :port    => 443,
          :position => 2
        )
      end
    end

    context 'when configured not to allow http' do
      let (:chef_run) do
        ChefSpec::SoloRunner.new do | node |
          node.normal['ssh']['host_port'] = ssh_port
          node.normal['ingenerator']['default_firewall']['allow_http'] = false
        end.converge(described_recipe)
      end

      it 'does not allow http' do
        expect(chef_run).not_to create_firewall_rule('http')
      end
    end

    context 'when configured not to allow https' do
      let (:chef_run) do
        ChefSpec::SoloRunner.new do | node |
          node.normal['ssh']['host_port'] = ssh_port
          node.normal['ingenerator']['default_firewall']['allow_https'] = false
        end.converge(described_recipe)
      end

      it 'does not allow http' do
        expect(chef_run).not_to create_firewall_rule('https')
      end
    end

  end

  shared_examples 'it does not provision the firewall' do
    it 'does not install firewall' do
      expect(chef_run).not_to include_recipe('firewall::default')
    end

    it 'does not create any firewall rules' do
      expect(chef_run.find_resources('firewall_rule')).to eq([])
    end

  end

  context 'when running in local-dev environment' do

    context 'by default' do
      let (:chef_run) do
        ChefSpec::SoloRunner.new do | node |
          node.normal['ingenerator']['node_environment'] = :localdev
        end.converge(described_recipe)
      end

      include_examples 'it does not provision the firewall'
    end

    context 'when explicitly configured to provision firewall' do
      let (:chef_run) do
        ChefSpec::SoloRunner.new do | node |
          node.normal['ingenerator']['node_environment']                   = :localdev
          node.override['ingenerator']['default_firewall']['do_provision'] = true
          node.normal['ssh']['host_port']                                  = 490
        end.converge(described_recipe)
      end

      it 'installs the firewall using the default recipe' do
        expect(chef_run).to include_recipe('firewall::default')
      end
    end

  end

  context 'when configured not to provision firewall' do

    let (:chef_run) do
      ChefSpec::SoloRunner.new do | node |
        node.normal['ingenerator']['default_firewall']['do_provision'] = false
      end.converge(described_recipe)
    end

    include_examples 'it does not provision the firewall'
  end

end
