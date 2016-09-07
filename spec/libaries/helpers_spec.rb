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

  describe 'node_environment' do
    it 'returns :production if nothing configured' do
      allow(my_recipe).to receive(:node).and_return({})
      expect(my_recipe.node_environment).to eq(:production)
    end

    it 'returns configured environment' do
      allow(my_recipe).to receive(:node).and_return({
        'ingenerator' => {'node_environment' => :localdev}
      })
      expect(my_recipe.node_environment).to eq(:localdev)
    end
  end

  describe 'is_environment?' do
    before (:each) do
      allow(my_recipe).to receive(:node).and_return({})
    end

    it 'is true if environment matches' do
      expect(my_recipe.is_environment?(:production)).to be(true)
    end

    it 'is false if environment does not match' do
      expect(my_recipe.is_environment?(:localdev)).to be(false)
    end
  end

  describe 'not_environment?' do
    before (:each) do
      allow(my_recipe).to receive(:node).and_return({})
    end

    it 'is false if environment matches' do
      expect(my_recipe.not_environment?(:production)).to be(false)
    end

    it 'is true if environment does not match' do
      expect(my_recipe.not_environment?(:localdev)).to be(true)
    end
  end


end
