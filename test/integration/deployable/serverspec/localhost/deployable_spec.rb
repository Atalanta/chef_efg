require 'spec_helper'

describe 'EFG Deployable Recipe' do

  it 'createa a deploy user' do
    expect(user 'deploy').to exist
  end

  it 'adds an SSH key' do
    expect(file('/home/deploy/.ssh/authorized_keys').content).to match /MzmgYqJiQ4V/
  end

  it 'installs the sqlite development library' do
    expect(package 'libsqlite3-dev').to be_installed
  end

  it 'installs git' do
    expect(package 'git').to be_installed
  end

  it 'installs bundler' do
    expect(command('gem list')).to return_stdout /^bundler/
  end

  it 'renders a database.yml file' do
    config = '/home/deploy/efg/shared/config/database.yml'
    expect(file(config)).to be_file
    expect(file(config)).to be_owned_by 'deploy'
    expect(file(config).content).to match /production:/
  end

end
