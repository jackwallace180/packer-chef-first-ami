#
# Cookbook:: node_2
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

apt_update 'update_sources' do
  action :update
end

#provision nginx
package 'nginx'
service 'nginx' do
  action [:enable, :start]
end

#provision nodejs and pm2
include_recipe 'nodejs'
nodejs_npm 'pm2'

#syntax to move our file.
#template'destination'
#source 'name file_in_templates.conf.erb'
template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables(proxy_port: node['nginx']['proxy_port'],
  proxy_port_2: node['nginx']['proxy_port_mutton'])
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]'
end
