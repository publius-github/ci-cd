#!/bin/bash

# Disable SeLinux

sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
setenforce 0

# Update all packages
sudo yum -y update

# Add Puppet repo and install Puppet
sudo rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm
sudo yum -y install puppet-agent
sudo yum install gem -y
sudo gem install librarian-puppet
# sudo /opt/puppetlabs/puppet/bin/gem install --no-rdoc --no-ri librarian-puppet # hiera-eyaml google-api-client
# sudo /opt/puppetlabs/puppet/bin/gem install librarian-puppet
cd /opt/cicd/puppet/
export PATH=/opt/puppetlabs/bin:$PATH
/usr/local/bin/librarian-puppet install

sudo yum clean all

var=$(ec2-metadata | grep security-groups | awk '{ print $2 }')
var2="role=$var"

# PROJECTID=$(/opt/puppetlabs/bin/facter gce.project.projectId)
# PROJECT=$(/opt/puppetlabs/bin/facter gce.project.attributes.project)
# ENVNAME=$(/opt/puppetlabs/bin/facter gce.project.attributes.envname)

ROLE=$(/opt/puppetlabs/bin/facter $var)
# REGION=$(/opt/puppetlabs/bin/facter gce.instance.zone | cut -f -2 -d '-')
# ZONE=$(/opt/puppetlabs/bin/facter gce.instance.zone)

mkdir -p /etc/facter/facts.d

cat > /etc/facter/facts.d/gcp.txt <<- EOF
$var2
EOF

chmod -R 700 /etc/facter/

echo "Run puppet apply"
/opt/puppetlabs/bin/puppet apply -d --hiera_config=/opt/cicd/puppet/hiera.yaml --modulepath=/opt/cicd/puppet/localmodules/:/opt/cicd/puppet/modules/  /opt/cicd/puppet/manifests/site.pp -l /var/log/puppet.log
echo "End puppet apply"
