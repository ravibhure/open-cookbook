maintainer        "Ravi Bhure."
maintainer_email  "ravibhure@gmail.com"
license           "Apache 2.0"
description       "Installs and configures haproxy"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.7"

%w{ redhat centos fedora }.each do |os|
  supports os
end
