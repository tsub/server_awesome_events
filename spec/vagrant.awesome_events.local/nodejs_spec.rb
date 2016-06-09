require 'spec_helper'

describe package('nodejs') do
  it { should be_installed }
end
