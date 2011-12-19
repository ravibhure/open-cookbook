maintainer        "Ravi Bhure."
maintainer_email  "ravibhure@gmail.com"
license           "Apache 2.0"
description       "Installs and configures haproxy"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.0.1"
recipe "haproxy::default", "HAproxy recipe, Installs and configures HAproxy"
recipe "haproxy::dbsetup", "HAproxy recipe, configures HAproxy db"

%w{ redhat centos fedora }.each do |os|
  supports os
end

attribute "haproxy/db_adapter",
  :display_name => "Database Adapter",
  :description => "Database adapter to connect to Database. (Ex: mysql)",
  :default => "postgres",
  :choice => [ "mysql", "postgres" ],
  :recipes => [ "haproxy::dbsetup" ]
