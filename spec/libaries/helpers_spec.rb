require 'spec_helper'
require_relative '../../libraries/helpers.rb'

describe Ingenerator::Base::Helpers do
  let (:my_recipe) { Class.new { extend Ingenerator::Base::Helpers } }
  let (:node)      { {} }

  before (:example) do
    allow(my_recipe).to receive(:node).and_return node
  end

  shared_examples 'it raises exception in any environment' do

    it 'raises exception in development environments' do
      allow(node).to receive(:'is_environment?').with(:localdev, :buildslave).and_return true
      expect {
        my_recipe.custom_ssh_port
      }.to raise_exception(ArgumentError)
    end

    it 'raises exception in production environments' do
      allow(node).to receive(:'is_environment?').with(:localdev, :buildslave).and_return false
      expect {
        my_recipe.custom_ssh_port
      }.to raise_exception(ArgumentError)
    end

  end

  describe 'custom_ssh_port' do
    context 'if no port is defined in node attributes' do
      let (:node) { {} }

      include_examples 'it raises exception in any environment'
    end

    context 'if defined port is not an integer' do
      let (:node) { {'ssh' => {'host_port' => 'ab823'}} }

      include_examples 'it raises exception in any environment'
    end

    context 'if defined port is valid' do
      let (:node) { {'ssh' => {'host_port' => 9823}} }

      it 'returns configured port number in production environments' do
        allow(node).to receive(:'is_environment?').with(:localdev, :buildslave).and_return false
        expect(my_recipe.custom_ssh_port).to eq(9823)
      end

      it 'always returns port 22 in development environments' do
        allow(node).to receive(:'is_environment?').with(:localdev, :buildslave).and_return false
        expect(my_recipe.custom_ssh_port).to eq(9823)
      end
    end
  end
end
