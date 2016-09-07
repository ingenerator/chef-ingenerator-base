require 'spec_helper'

describe 'ingenerator-base::ssh_host' do
  let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
  let (:ssh_port) { 9920 }

  before(:example) do
    # Mock the custom ssh port helper
    allow_any_instance_of(Chef::Recipe).to receive(:custom_ssh_port).and_return(ssh_port)
  end
  
  context 'with ssh port configured' do

    it 'renders the sshd_config template with correct permissions' do
      expect(chef_run).to create_template('/etc/ssh/sshd_config').with(
        :owner => 'root',
        :group => 'root',
        :mode => 0644
      )
    end

    it 'renders the sshd_config template with configured ssh port' do
      expect(chef_run).to render_file('/etc/ssh/sshd_config').with_content("\nPort #{ssh_port}\n")
    end

    it 'defines the ssh service for notification and notifies it to restart' do
      template = chef_run.template('/etc/ssh/sshd_config')
      expect(template).to notify('service[ssh]').to(:restart)
    end

  end
end
