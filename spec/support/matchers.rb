# Custom matchers for resources that don't define their own

def create_hostsfile_entry(ip)
  ChefSpec::Matchers::ResourceMatcher.new(:hostsfile_entry, :create, ip)
end
def remove_hostsfile_entry(ip)
  ChefSpec::Matchers::ResourceMatcher.new(:hostsfile_entry, :remove, ip)
end
