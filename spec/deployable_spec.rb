require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|

  config.platform = 'ubuntu'
  config.version = '14.04'
  


  describe 'efg::deployable' do

    before(:each) do
      stub_command(/apt-key list/).and_return(false)
    end


    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it 'creates the deploy user' do
      expect(chef_run).to create_user('deploy').with({shell: '/bin/bash', supports: {manage_home: true}})
    end

    it 'creates a home and shared config directory' do
      expect(chef_run).to create_directory('/home/deploy/efg/shared/config').with(owner: 'deploy', mode: '0755', recursive: true)
    end    

    it 'creates an ssh directory' do
      expect(chef_run).to create_directory('/home/deploy/.ssh').with({owner: 'deploy', mode: '0700'})
    end

    it 'creates an authorized keys file' do
      expect(chef_run).to render_file('/home/deploy/.ssh/authorized_keys').with_content( /MzmgYqJiQ4V/ )
      expect(chef_run).to create_template('/home/deploy/.ssh/authorized_keys').with(mode: '0600')
    end

    it 'installs sqlite development library' do
      expect(chef_run).to install_package 'libsqlite3-dev'
    end

    it 'includes the appserver recipe' do
      expect(chef_run).to include_recipe 'efg::appserver'
    end 

    it 'installs git' do
      expect(chef_run).to install_package 'git'
    end

    it 'installs bundler' do
      expect(chef_run).to install_gem_package 'bundler'
    end
    
    it 'renders a database config' do

      expect(chef_run).to render_file('/home/deploy/efg/shared/config/database.yml').with_content(/production/)
    end

  end

end
