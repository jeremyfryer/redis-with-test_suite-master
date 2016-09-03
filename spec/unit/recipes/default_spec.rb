#
# Cookbook Name:: redis
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'redis::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(step_into: ['redis']) do |node,server|
        node.set['redis']['version'] = version
      end
      runner.converge(described_recipe)
    end

    let(:version) { '2.8.9' }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs the necessary packages' do
      expect(chef_run).to install_package('build-essential')
      expect(chef_run).to install_package('tcl8.5')
    end

    it 'installs redis' do
      expect(chef_run).to install_redis(version)
    end

    it 'pulls down the remote file' do
      expect(chef_run).to create_remote_file("/tmp/redis-#{version}.tar.gz")
    end

    it 'pulls down the remote file' do
      resource = chef_run.remote_file("/tmp/redis-#{version}.tar.gz")
      expect(resource).to notify('execute[unzip_redis_archive]').to(:run).immediately
    end

    it 'unzip redis archive' do
      resource = chef_run.execute('unzip_redis_archive')
      expect(resource).to notify('execute[build_and_install_redis]').to(:run).immediately
    end

    it 'builds and installs redis' do
      resource = chef_run.execute('build_and_install_redis')
      expect(resource).to notify('execute[install_server_redis]').to(:run).immediately
    end

    it 'starts the service' do
      expect(chef_run).to start_service('redis_6379')
    end

    it 'enables the service' do
      expect(chef_run).to enable_service('redis_6379')
    end
  end
end
