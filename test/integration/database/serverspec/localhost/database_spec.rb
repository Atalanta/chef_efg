require 'spec_helper'

describe 'EFG Database Recipe' do
  
  it 'should install MySQL' do
    expect(package 'mysql-server-5.5').to be_installed
  end

  it 'should start and enable MySQL' do
    expect(service('mysql')).to be_running
    expect(service('mysql')).to be_enabled
  end

  it 'should create an EFG database' do
    show_databases = "echo 'show databases;' | mysql -uroot -pilikerandompasswords"
    expect(command(show_databases)).to return_stdout /efg/
  end

  it 'should create an EFG user/password' do
    show_variables = "echo 'show variables;' | mysql -uefg -pefg efg"
    expect(command(show_variables)).to return_stdout /version\s+5\.5.*ubuntu/
  end

end

