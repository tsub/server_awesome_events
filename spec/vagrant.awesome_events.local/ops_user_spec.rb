require 'spec_helper'

describe user('ops') do
  it { should exist }
  it { should belong_to_primary_group 'ops' }
end
