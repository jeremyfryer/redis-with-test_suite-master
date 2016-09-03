if defined?(ChefSpec)
  def install_redis(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:redis, :install, resource_name)
  end
end
