require 'spec_helper'

describe 'ingenerator-base::base_packages' do
  let (:chef_run) { ChefSpec::SoloRunner.new.converge described_recipe }

  context 'with packages configured' do
    it "installs each package" do
      chef_run.node.set['base']['packages'] = { 'pckg1' => true, 'pckg2' => true }
      chef_run.converge(described_recipe)
      chef_run.should install_package('pckg1')
      chef_run.should install_package('pckg2')
    end
  end

  context 'with some packages disabled' do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['base']['packages'] = {
          'active'   => true,
          'inactive' => false
        }
      end.converge(described_recipe)
    end

    it "installs the enabled package" do
      chef_run.should install_package('active')
    end

    it "does not install the disabled package" do
      chef_run.should_not install_package('inactive')
    end
  end

  context 'by default' do
    it "installs git" do
      chef_run.should install_package('git')
    end
  end

end
