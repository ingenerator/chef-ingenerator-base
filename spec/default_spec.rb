require 'spec_helper'

describe 'ingenerator-base::default' do
  let (:chef_run) { ChefSpec::Runner.new.converge described_recipe }

  it "runs apt recipe to ensure all apt sources are up to date" do
    chef_run.should include_recipe('apt::default')
  end

  it "runs base_packages recipe to install configured base packages" do
    chef_run.should include_recipe('ingenerator-base::base_packages')
  end

end
