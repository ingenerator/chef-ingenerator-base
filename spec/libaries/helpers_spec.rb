require 'spec_helper'
require_relative '../../libraries/helpers.rb'

describe Ingenerator::Base::Helpers do
  let (:my_recipe) { Class.new { extend Ingenerator::Base::Helpers }}

  describe 'custom_ssh_port' do
    it 'throws exception if no port is defined in node attributes' do
      allow(my_recipe).to receive(:node).and_return({})

      expect {
        my_recipe.custom_ssh_port
      }.to raise_exception(ArgumentError)
    end

    it 'throws exception if defined port is not an integer' do
      allow(my_recipe).to receive(:node).and_return({'ssh' => {'host_port' => 'ab824'}})

      expect {
        my_recipe.custom_ssh_port
      }.to raise_exception(ArgumentError)
    end

    it 'returns valid port defined in node attributes' do
      allow(my_recipe).to receive(:node).and_return({'ssh' => {'host_port' => 9823}})
      expect(my_recipe.custom_ssh_port).to eq(9823)
    end

    shared_examples 'it always uses port 22 in this environment' do | node_environment |

      it 'throws exception if no port is defined in node attributes' do
        allow(my_recipe).to receive(:node).and_return({})

        expect {
          my_recipe.custom_ssh_port
        }.to raise_exception(ArgumentError)
      end

      it 'always returns port 22' do
        allow(my_recipe).to receive(:node).and_return({
          'ingenerator' => {'node_environment' => node_environment},
          'ssh'         => {'host_port' => 9823}
        })
        expect(my_recipe.custom_ssh_port).to eq(22)
      end

    end

    context 'in localdev environment' do
      include_examples 'it always uses port 22 in this environment', :localdev
    end

    context 'in buildslave environment' do
      include_examples 'it always uses port 22 in this environment', :buildslave
    end

  end

  shared_examples 'it handles the node_environment as expected' do | is_environment, not_environment |

    describe 'node_environment' do
      it "is :#{is_environment}" do
        expect(my_recipe.node_environment).to be(is_environment)
      end
    end

    describe 'is_environment?' do
      it "matches :#{is_environment}" do
        expect(my_recipe.is_environment?(is_environment)).to be(true)
      end

      it "matches '#{is_environment}'" do
        expect(my_recipe.is_environment?("#{is_environment}")).to be(true)
      end

      it "does not match :#{not_environment}" do
        expect(my_recipe.is_environment?(not_environment)).to be(false)
      end

      it "does not match '#{not_environment}'" do
        expect(my_recipe.is_environment?("#{not_environment}")).to be(false)
      end
    end

    describe 'not_environment?' do
      it "matches :#{not_environment}" do
        expect(my_recipe.not_environment?(not_environment)).to be(true)
      end

      it "matches '#{not_environment}'" do
        expect(my_recipe.not_environment?("#{not_environment}")).to be(true)
      end

      it "does not match :#{is_environment}" do
        expect(my_recipe.not_environment?(is_environment)).to be(false)
      end

      it "does not match '#{is_environment}'" do
        expect(my_recipe.not_environment?("#{is_environment}")).to be(false)
      end

    end
  end

  context 'when no node_environment is configured' do
    before(:each) do
      allow(my_recipe).to receive(:node).and_return({})
    end

    include_examples 'it handles the node_environment as expected', :production, :localdev
  end

  context "when node_environment is configured as (string) 'buildslave'" do
    before(:each) do
      allow(my_recipe).to receive(:node).and_return({
        'ingenerator' => {'node_environment' => 'buildslave'}
      })
    end

    include_examples 'it handles the node_environment as expected', :buildslave, :production
  end

  context 'when node_environment is configured as (symbol) :localdev' do
    before(:each) do
      allow(my_recipe).to receive(:node).and_return({
        'ingenerator' => {'node_environment' => :localdev}
      })
    end

    include_examples 'it handles the node_environment as expected', :localdev, :production
  end

end
