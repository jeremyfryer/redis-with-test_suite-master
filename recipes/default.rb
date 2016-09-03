#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# Translated Instructions From:
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-redis
#

execute "apt-get update"

package "build-essential"

package "tcl8.5"

redis node['redis']['version'] do
  source "http://download.redis.io/releases/redis-#{node['redis']['version']}.tar.gz"
end

service "redis_6379" do
  action [ :start, :enable ]
  # This is necessary so that the service will not keep reporting as updated
  supports :status => true
end
