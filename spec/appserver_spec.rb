require 'chefspec'
require 'chefspec/berkshelf'
#require 'chefspec/server'

RSpec.configure do |config|

  config.platform = 'ubuntu'
  config.version = '14.04'
  


  describe 'efg::appserver' do

    before(:each) do
      stub_command(/apt-key list/).and_return(false)
    end

    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
    
    it 'includes the default passenger_nginx recipe' do
      expect(chef_run).to include_recipe 'passenger_nginx'
    end

    it 'creates a virtual host for EFG' do
      expect(chef_run).to create_passenger_nginx_vhost('efg')
    end

  end

end
