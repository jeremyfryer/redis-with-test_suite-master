#
# Cookbook Name:: redis
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'redis::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs the necessary packages' do
      expect(chef_run).to install_package('build-essential')
      expect(chef_run).to install_package('tcl8.5')
    end

    it 'pulls down the remote file' do
      expect(chef_run).to create_remote_file('/tmp/redis-2.8.9.tar.gz')
    end

    it 'installs the redis from source' do
      chef_run.execute('unzip_redis_archive')
    end

    it 'starts the service' do
      expect(chef_run).to start_service('redis_6379')
    end

    it 'enables the service' do
      expect(chef_run).to enable_service('redis_6379')
    end
  end
end
