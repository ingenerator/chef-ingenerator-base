require 'spec_helper'

describe 'ingenerator-base::default' do
  let (:chef_run) do
     ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04') do | node |
        node.normal['ssh']['host_port'] = 22
     end.converge described_recipe
  end

  it "runs apt recipe to ensure all apt sources are up to date" do
    expect(chef_run).to include_recipe('apt::default')
  end

  it "runs base_packages recipe to install configured base packages" do
    expect(chef_run).to include_recipe('ingenerator-base::base_packages')
  end

  it "runs localhost_aliases recipe to set up hostsfile entries for localhost" do
    expect(chef_run).to include_recipe('ingenerator-base::localhost_aliases')
  end

  it "removes the chef-client service" do
    expect(chef_run).to disable_service('chef-client')
    expect(chef_run).to stop_service('chef-client')
  end
  
  it "sets the timezone to UTC" do
    expect(chef_run.node['tz']).to eq('Etc/UTC')
    expect(chef_run).to include_recipe('timezone-ii::default')
  end
  
  it "includes the swap recipe" do
    expect(chef_run).to include_recipe('ingenerator-base::swap')
  end

  it 'includes the ssh_host recipe' do
    expect(chef_run).to include_recipe('ingenerator-base::ssh_host')
  end

  it 'includes the default firewall recipe' do
    expect(chef_run).to include_recipe('ingenerator-base::firewall')
  end

  context "with default attributes" do
    it "defines a project name attribute" do
      expect(chef_run.node['project']['name']).to eq('newproject')
    end

    it "defines a project contact email" do
      expect(chef_run.node['project']['contact']).to eq('hello@ingenerator.com')
    end

    it 'defaults the node environment to be production' do
      expect(chef_run.node['ingenerator']['node_environment']).to eq(:production)
    end
  end

end
