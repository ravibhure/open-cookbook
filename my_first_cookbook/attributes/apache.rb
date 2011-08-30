#
# Cookbook Name:: my_first_cookbook
# Attributes:: apache
#
# Copyright (c) 2011 Ravi Bhure

#
# Recommended attributes
#
set_unless[:apache][:contact] = "root@localhost"

#
# Optional attributes
#
# Turning off Keepalive to prevent conflicting HAproxy
set_unless[:apache][:keepalive] = "Off" 
# Turn on generation of "full" apache status
set_unless[:apache][:extended_status] = "On"
#  worker = multithreaded
#  prefork = single-threaded (use for php)
set_unless[:apache][:mpm] = "prefork"
# Security: Configuring Server Signature
set_unless[:apache][:serversignature] = "Off "
# DISTRO specific config dir
case platform
when "ubuntu", "debian"
  set[:apache][:config_subdir] = "apache2"
when "centos", "fedora", "suse"
  set[:apache][:config_subdir] = "httpd"
end

set_unless[:my_first_cookbook][:ssl_enable] = false
set_unless[:my_first_cookbook][:ssl_certificate] = nil
set_unless[:my_first_cookbook][:ssl_certificate_chain] = nil
set_unless[:my_first_cookbook][:ssl_key] = nil
set_unless[:my_first_cookbook][:ssl_passphrase] = nil

# Used to be called php/code/destination
set[:my_first_cookbook][:docroot] = "/home/webapp/#{my_first_cookbook[:application_name]}"