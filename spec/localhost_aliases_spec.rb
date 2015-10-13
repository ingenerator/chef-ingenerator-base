require 'spec_helper'

describe 'ingenerator-base::localhost_aliases' do
  
  context "by default" do
    let (:chef_run) { ChefSpec::SoloRunner.new.converge described_recipe }
    it "creates a hostsfile entry for localhost" do
      chef_run.should create_hostsfile_entry('127.0.0.1').with(
        hostname: 'localhost'
      )
    end
  end

  context "with default localhost alias disabled" do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['base']['localhost_aliases']['localhost'] = false
      end.converge(described_recipe)
    end

    it "does not create a hostsfile entry" do
      chef_run.should_not create_hostsfile_entry('127.0.0.1')
    end

    it "removes any hostsfile entry for localhost" do
      chef_run.should remove_hostsfile_entry('127.0.0.1')
    end
  end

  context "with default localhost alias disabled and additional alias" do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['base']['localhost_aliases'] = {'localhost' => false, 'project.dev' => true}
      end.converge(described_recipe)
    end

    it "creates a hostsfile entry for localhost with alias as hostname" do
      chef_run.should create_hostsfile_entry('127.0.0.1').with(
        hostname: 'project.dev'
      )
    end

    it "adds a comment to identify the entry source" do
      chef_run.should create_hostsfile_entry('127.0.0.1').with(
        comment: 'Added by ingenerator-base::localhost_aliases recipe by chef'
      )
    end
  end

  context "with multiple aliases" do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.default['base']['localhost_aliases'] = {}
        node.set['base']['localhost_aliases'] = {'localhost' => true, 'project.dev' => true, 'cdn.project.dev' => true, 'api.project.dev' => true}
      end.converge(described_recipe)
    end

    it "appends the first alias to the hostsfile as hostname" do
      chef_run.should create_hostsfile_entry('127.0.0.1').with(
        hostname: 'localhost'
      )
    end

    it "appends subsequent aliases to the hostsfile as aliases" do
      chef_run.should create_hostsfile_entry('127.0.0.1').with(
        aliases: ['project.dev', 'cdn.project.dev', 'api.project.dev']
      )
    end

  end

  context "with multiple aliases where one is disabled" do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['base']['localhost_aliases'] = {'localhost' => false, 'project.dev' => true, 'cdn.project.dev' => true, 'api.project.dev' => true}
      end.converge(described_recipe)
    end

    it "appends the first alias to the hostsfile as hostname" do
      chef_run.should create_hostsfile_entry('127.0.0.1').with(
        hostname: 'project.dev'
      )
    end

    it "appends subsequent aliases to the hostsfile as aliases" do
      chef_run.should create_hostsfile_entry('127.0.0.1').with(
        aliases: ['cdn.project.dev', 'api.project.dev']
      )
    end
  end

  context "with multiple aliases where all are disabled" do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['base']['localhost_aliases'] = {
          'localhost'       => false,
          'project.dev'     => false,
          'cdn.project.dev' => false
        }
      end.converge(described_recipe)
    end

    it "does not create a hostsfile entry" do
      chef_run.should_not create_hostsfile_entry('127.0.0.1')
    end

    it "removes any hostsfile entry for localhost" do
      chef_run.should remove_hostsfile_entry('127.0.0.1')
    end
  end

end
