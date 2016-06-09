require 'spec_helper'

describe package('libsqlite3-dev') do
  it { should be_installed }
end

describe package('sqlite3') do
  it { should be_installed }
end
