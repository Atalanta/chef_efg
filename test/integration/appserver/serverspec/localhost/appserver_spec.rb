require 'spec_helper'

describe 'EFG App Server' do

  context 'Passenger config' do  
    it 'should create a config snippet under sites available' do
      expect(file('/etc/nginx/sites-available/efg')).to be_file
    end
    
    it 'should link the config into sites enabled' do
      expect(file('/etc/nginx/sites-enabled/efg')).to be_linked_to '/etc/nginx/sites-available/efg'
    end
    
    it 'should listen on port 80' do
      expect(file('/etc/nginx/sites-enabled/efg').content).to match /^\s+listen 80 default_server;$/
    end
    
    it 'should use efg.net as the server_name' do
      expect(file('/etc/nginx/sites-enabled/efg').content).to match /^\s+server_name efg.net;$/
    end
    
    it 'should enable passenger' do
      expect(file('/etc/nginx/sites-enabled/efg').content).to match /^\s+passenger_enabled on;$/
    end
    
    it 'should use the production rails environment' do
      expect(file('/etc/nginx/sites-enabled/efg').content).to match /^\s+rails_env\s+production;$/
    end
    
    it 'should set the document root to /home/deploy/efg/current/public' do
      expect(file('/etc/nginx/sites-enabled/efg').content).to match /^\s+root\s+\/home\/deploy\/efg\/current\/public;$/
    end

    
  end

  context 'Nginx and Passenger' do
    it 'should install Nginx with embedded Passenger' do
      expect(package 'nginx-full').to be_installed
      expect(package 'passenger').to be_installed
      expect(command 'nginx -v').to return_stdout /^nginx version: nginx\/\d+.\d+.\d+$/
      expect(command 'passenger --version').to return_stdout /^Phusion Passenger version \d+.\d+.\d+$/
    end
  end
end
