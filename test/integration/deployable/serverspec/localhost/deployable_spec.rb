require 'spec_helper'

describe 'EFG Deployable Recipe' do

  it 'should create a deploy user' do
    expect(user 'deploy').to exist
  end

  it 'should add the SSH key' do
    expect(file('/home/deploy/.ssh/authorized_keys').content).to match /MzmgYqJiQ4V/
  end

  it 'should install sqlite' do
    expect(package 'libsqlite3-dev').to be_installed
  end

  it 'should install git' do
    expect(package 'git').to be_installed
  end

  it 'should install bundler' do
    expect(command('gem list')).to return_stdout /^bundler/
  end

end
