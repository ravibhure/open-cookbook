maintainer       "Home, Inc."
maintainer_email "ravibhure@gmail.com"
license           "Apache 2.0"
description      "Installs/configures a PostgreSQL database server with automated backups."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

recipe  "db_postgres::default", "Runs the client 'db_postgres::install_client' recipes."
recipe  "db_postgres::setup_monitoring", "Runs to setup monitoring on client  'db_postgres::setup_monitoring' recipes."

attribute "db_postgres",
  :display_name => "General Database Options",
  :type => "hash"
  
# == Default attributes
#
attribute "db_postgres/server_usage",
  :display_name => "Server Usage",
  :description => "Use 'dedicated' if the postgres config file allocates all existing resources of the machine.  Use 'shared' if the PostgreSQL config file is configured to use less resources so that it can be run concurrently with other apps like Apache and Rails for example.",
  :recipes => [
    "db_postgres::default"
  ],
  :choice => ["shared", "dedicated"],
  :default => "dedicated"

