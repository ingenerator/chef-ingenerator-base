require 'spec_helper'

describe 'ingenerator-base::swap' do
  let (:swap_path)    { '/mnt/customswap' }
  let (:swap_size)    { 999               }
  let (:swap_persist) { false             }
  
  context "with custom configuration" do
    let (:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do | node |
        node.set['swap']['path']    = swap_path
        node.set['swap']['size']    = swap_size
        node.set['swap']['persist'] = swap_persist
      end.converge(described_recipe)
    end
  
    it "creates a swap file with configured attributes" do
      chef_run.should create_swap_file(swap_path).with({
        :size    => swap_size,
        :persist => swap_persist
      })
    end
  end
  
  context "by default" do
    let (:chef_run) { ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04').converge described_recipe }
    
    it "creates the file at /mnt/swap by default" do
      chef_run.node['swap']['path'].should eq('/mnt/swap')
    end
    
    it "sets size to 1024Mb by default" do
      chef_run.node['swap']['size'].should eq(1024)
    end
    
    it "makes the swap persistent" do
      chef_run.node['swap']['persist'].should eq(true)
    end
  end

end
