require 'spec_helper'

describe 'ingenerator-base::default' do
  let (:chef_run) { ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04').converge described_recipe }

  it "runs apt recipe to ensure all apt sources are up to date" do
    chef_run.should include_recipe('apt::default')
  end

  it "runs base_packages recipe to install configured base packages" do
    chef_run.should include_recipe('ingenerator-base::base_packages')
  end

  it "runs localhost_aliases recipe to set up hostsfile entries for localhost" do
    chef_run.should include_recipe('ingenerator-base::localhost_aliases')
  end

  it "removes the chef-client service" do
    chef_run.should disable_service('chef-client')
    chef_run.should stop_service('chef-client')
  end
  
  it "sets the timezone to UTC" do
    chef_run.node['tz'].should eq('UTC')
    chef_run.should include_recipe('timezone-ii::default')
  end
  
  it "includes the swap recipe" do
    chef_run.should include_recipe('ingenerator-base::swap')
  end

  context "with default attributes" do
    it "defines a project name attribute" do
      chef_run.node['project']['name'].should eq('newproject')
    end

    it "defines a project contact email" do
      chef_run.node['project']['contact'].should eq('hello@ingenerator.com')
    end

  end

end
