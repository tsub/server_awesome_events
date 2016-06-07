# Cookbook Name:: rails_book_cookbook
# Recipe:: ruby

include_recipe 'rails_book_cookbook::ops_user'

%w{libreadline-dev libyaml-dev libssl-dev libffi-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

git '/home/ops/.rbenv' do
  repository 'git://github.com/sstephenson/rbenv.git'
  reference 'master'
  action :sync
  user 'ops'
  group 'ops'
end

directory '/home/ops/.rbenv/plugins' do
  action :create
  user 'ops'
  group 'ops'
end

git '/home/ops/.rbenv/plugins/ruby-build' do
  repository 'git://github.com/sstephenson/ruby-build.git'
  reference 'master'
  action :sync
  user 'ops'
  group 'ops'
end

bash 'insert_line_rbenvpath' do
  environment 'HOME' => '/home/ops'
  code <<-EOS
    echo 'export PATH="/home/ops/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    chmod 777 ~/.bashrc
    source ~/.bashrc
  EOS
  not_if 'grep rbenv ~/.bashrc', environment: { 'HOME' => '/home/ops' }
end

bash 'install ruby' do
  user 'ops'
  group 'ops'
  environment 'HOME' => '/home/ops'
  code <<-EOS
    /home/ops/.rbenv/bin/rbenv install 2.3.1
    /home/ops/.rbenv/bin/rbenv rehash
    /home/ops/.rbenv/bin/rbenv global 2.3.1
  EOS
  not_if { File.exists?('/home/ops/.rbenv/versions/2.3.1') }
end

gem_package 'bundler' do
  gem_binary '/home/ops/.rbenv/versions/2.3.1/bin/gem'
end