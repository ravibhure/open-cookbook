maintainer       "Home, Inc."
maintainer_email "ravibhure@gmail.com"
license           "Apache 2.0"
description      "Installs/configures a PostgreSQL database server with automated backups."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

depends "rs_utils"

recipe  "db_postgres::default", "Runs the client 'db_postgres::install_client' recipes."
recipe  "db_postgres::install_server", "Runs the server 'db_postgres::install_server' recipes."
recipe  "db_postgres::setup_monitoring", "Installs the collectd plugin for database monitoring support, which is required to enable monitoring and alerting functionality for your servers."

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


attribute "db/fqdn",
  :display_name => "Database Master FQDN",
  :description => "The fully qualified domain name for the Master Database.",
  :required => true,
  :recipes => [ "db_postgres::default", "db_postgres::install_server" ]

attribute "db_postgres/admin/user",
  :display_name => "Database Admin Username",
  :description => "The username of the database user that has 'admin' privileges.",
  :required => false,
  :recipes => [ "db_postgres::install_server" ]

attribute "db_postgres/admin/password",
  :display_name => "Database Admin Password",
  :description => "The password of the database user that has 'admin' privileges.",
  :required => false,
  :recipes => [ "db_postgres::install_server" ]

attribute "db_postgres/replication/user",
  :display_name => "Database Replication Username",
  :description => "The username of the database user that has 'replciation' privileges.",
  :required => false,
  :recipes => [ "db_postgres::install_server" ]

attribute "db_postgres/replication/password",
  :display_name => "Database Replication Password",
  :description => "The password of the database user that has 'replciation' privileges.",
  :required => false,
  :recipes => [ "db_postgres::install_server" ]
