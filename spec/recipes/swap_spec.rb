require 'spec_helper'

describe 'ingenerator-base::swap' do
  let (:swap_path)    { '/mnt/customswap' }
  let (:swap_size)    { 999               }
  let (:swap_persist) { false             }
  
  context "with custom configuration" do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do | node |
        node.normal['swap']['path']    = swap_path
        node.normal['swap']['size']    = swap_size
        node.normal['swap']['persist'] = swap_persist
      end.converge(described_recipe)
    end
  
    it "creates a swap file with configured attributes" do
      expect(chef_run).to create_swap_file(swap_path).with({
        :size    => swap_size,
        :persist => swap_persist
      })
    end
  end
  
  context "by default" do
    let (:chef_run) { ChefSpec::SoloRunner.new.converge described_recipe }
    
    it "creates the file at /mnt/swap by default" do
      expect(chef_run.node['swap']['path']).to eq('/mnt/swap')
    end
    
    it "sets size to 1024Mb by default" do
      expect(chef_run.node['swap']['size']).to eq(1024)
    end
    
    it "makes the swap persistent" do
      expect(chef_run.node['swap']['persist']).to eq(true)
    end
  end

end
