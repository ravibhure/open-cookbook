# Cookbook Name:: rs_utils
# Recipe:: install_postgresql_collectd_plugin
#
# Copyright (c) 2011 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

rs_utils_marker :begin

# Load the postgresql plugin in the main config file
rs_utils_enable_collectd_plugin "postgresql"
#node[:rs_utils][:plugin_list] += " postgresql" unless node[:rs_utils][:plugin_list] =~ /postgresql/

include_recipe "rs_utils::setup_monitoring"

log "Installing PostgreSQL collectd plugin"

package "collectd-postgresql" do
  only_if {  node[:platform] == "centos" }
end

remote_file "#{node[:rs_utils][:collectd_plugin_dir]}/postgresql.conf" do
  backup false
  source "collectd.postgresql.conf"
  notifies :restart, resources(:service => "collectd")
end

# When using the dot notation the following error is thrown
#
# You tried to set a nested key, where the parent is not a hash-like object: rs_utils/process_list/process_list
#
# The only related issue I could find was for Chef 0.9.8 - http://tickets.opscode.com/browse/CHEF-1680
rs_utils_monitor_process "postmaster"
template File.join(node[:rs_utils][:collectd_plugin_dir], 'processes.conf') do
  backup false
  source "processes.conf.erb"
  notifies :restart, resources(:service => "collectd")
end

rs_utils_marker :end
