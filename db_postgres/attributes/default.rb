# Cookbook Name:: db_postgres_postgres
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

set_unless[:db_postgres][:fqdn] = ""
set_unless[:db_postgres][:data_dir] = "/mnt/storage"
set_unless[:db_postgres][:dir] = "/var/lib/pgsql/data"
set_unless[:db_postgres][:provider] = "db_postgres"
set_unless[:db_postgres][:admin][:user] = "root"
set_unless[:db_postgres][:admin][:password] = ""

set_unless[:db_postgres][:replication][:user] = nil
set_unless[:db_postgres][:replication][:password] = nil

set_unless[:db_postgres][:backup][:lineage] = ""

set_unless[:db_postgres][:backup][:force] = false

#
# Server state variables
#
set_unless[:db_postgres][:db_postgres_restored] = false         # A restore operation was performed on this server
set_unless[:db_postgres][:this_is_master] = false
set_unless[:db_postgres][:current_master_uuid] = nil
set_unless[:db_postgres][:current_master_ip] = nil
# Calculate recommended backup times for master/slave

set_unless[:db_postgres][:backup][:master][:minute] = 5 + rand(54) # backup starts random time between 5-59
set_unless[:db_postgres][:backup][:master][:hour] = rand(23) # once a day, random hour

user_set = true if db_postgres[:backup][:slave] && db_postgres[:backup][:slave][:minute]
set_unless[:db_postgres][:backup][:slave][:minute] = 5 + rand(54) # backup starts random time between 5-59

if db_postgres[:backup][:slave][:minute] == db_postgres[:backup][:master][:minute]
  log_msg = "WARNING: detected master and slave backups collision."
  unless user_set
    db_postgres[:backup][:slave][:minute] = db_postgres[:backup][:slave][:minute].to_i / 2
    log_msg += "  Changing slave minute to avoid collision: #{db_postgres[:backup][:slave][:minute]}"
  end
  Chef::Log.info log_msg
end

set_unless[:db_postgres][:backup][:slave][:hour] = "*" # every hour

# Monitoring specific
set_unless[:db_postgres][:collectd_plugin_dir] = "/etc/collectd/conf" # collectd plugin dir
