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

remote_file "/tmp/redis-2.8.9.tar.gz" do
  source "http://download.redis.io/releases/redis-2.8.9.tar.gz"
  notifies :run, "execute[unzip_redis_archive]", :immediately
end

execute "unzip_redis_archive" do
  command 'tar xzf redis-2.8.9.tar.gz'
  cwd "/tmp"
  action :nothing
  notifies :run, "execute[build_and_install_redis]", :immediately
end

execute "build_and_install_redis" do
  command 'make && make install'
  cwd "/tmp/redis-2.8.9"
  action :nothing
  notifies :run, "execute[install_server_redis]", :immediately
end

execute "install_server_redis" do
  command "echo -n | ./install_server.sh"
  cwd "/tmp/redis-2.8.9/utils"
  action :nothing
end

service "redis_6379" do
  action [ :start, :enable ]
  # This is necessary so that the service will not keep reporting as updated
  supports :status => true
end
