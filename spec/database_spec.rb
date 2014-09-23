require 'chefspec'
require 'chefspec/berkshelf'
#require 'chefspec/server'

RSpec.configure do |config|

  config.platform = 'ubuntu'
  config.version = '14.04'
  


  describe 'efg::database' do

    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
    
    it 'includes the MySQL server recipe' do
      expect(chef_run).to include_recipe 'mysql::server'
    end

    it 'includes the MySQL database recipe' do
      expect(chef_run).to include_recipe 'database::mysql'
    end

    it 'creates an EFG database' do
      # ChefSpec::Server.create_data_bag('databases', {
      #                                    'production' => {
      #                                    'username' => 'efg',
      #                                    'password' => 'efg'
      #                                  }
      #                                })

      expect(chef_run).to create_mysql_database('efg')
    end
    
    it 'creates an EFG user/password' do

      # ChefSpec::Server.create_data_bag('databases', {
      #                                    'production' => {
      #                                    'username' => 'efg',
      #                                    'password' => 'efg'
      #                                  }
      #                                })
      expect(chef_run).to grant_mysql_database_user('efg').with(password: 'efg')
    end
 
  end

end
