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
  end

end
