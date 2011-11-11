# Cookbook Name:: db_postgres
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

include_recipe "db_postgres::client"

# Create a group and user like the package will.
# Otherwise the templates fail.

group "postgres" do
  # Workaround lack of option for -r and -o...
  group_name "-r -o postgres"
  not_if { Etc.getgrnam("postgres") }
  gid 26
end

user "postgres" do
  # Workaround lack of option for -M and -n...
  username "-M -n postgres"
  not_if { Etc.getpwnam("postgres") }
  shell "/bin/bash"
  comment "PostgreSQL Server"
  home "/var/lib/pgsql"
  gid "postgres"
  system true
  uid 26
  supports :non_unique => true
end

package "postgresql" do
  case node.platform
  when "redhat","centos"
    package_name "postgresql#{node.postgresql.version.split('.').join}"
  else
    package_name "postgresql"
  end
end

case node.platform
when "redhat","centos"
  package "postgresql#{node.postgresql.version.split('.').join}-server"
when "fedora","suse"
  package "postgresql-server"
end

execute "/sbin/service postgresql initdb" do
  not_if { ::FileTest.exist?(File.join(node.postgresql.dir, "PG_VERSION")) }
end

service "postgresql" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  source "redhat.pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :reload, resources(:service => "postgresql")
end

template "#{node[:postgresql][:dir]}/postgresql.conf" do
  source "redhat.postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, resources(:service => "postgresql")
end
