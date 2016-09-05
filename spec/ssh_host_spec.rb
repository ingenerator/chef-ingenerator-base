require 'spec_helper'

describe 'ingenerator-base::ssh_host' do
  context 'when ssh port has not been explicitly configured' do
    let (:chef_run) { ChefSpec::SoloRunner.converge described_recipe }

    it 'raises an exception' do
      expect {
        chef_run
      }.to raise_error(ArgumentError)
    end
  end

  context 'when ssh port is not a valid numeric port number' do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do | node |
        node.normal['ssh']['host_port'] = 'ab82'
      end.converge(described_recipe)
    end

    it 'raises an exception' do
      expect {
        chef_run
      }.to raise_error(ArgumentError)
    end
  end

  context 'with ssh port configured' do
    let (:ssh_port)    { 2200 }

    let (:chef_run) do
      ChefSpec::SoloRunner.new do | node |
        node.normal['ssh']['host_port'] = ssh_port
      end.converge(described_recipe)
    end

    it 'renders the sshd_config template with correct permissions' do
      expect(chef_run).to create_template('/etc/ssh/sshd_config').with(
        :owner => 'root',
        :group => 'root',
        :mode => 0644
      )
    end

    it 'renders the sshd_config template with configured ssh port' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content("\nPort 2200\n")
    end

    it 'defines the ssh service for notification and notifies it to restart' do
      template = chef_run.template('/etc/ssh/sshd_config')
      expect(template).to notify('service[ssh]').to(:restart)
    end

  end
end
