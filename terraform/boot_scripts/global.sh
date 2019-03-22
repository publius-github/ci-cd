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
cd /opt/cicd/puppet/
export PATH=/opt/puppetlabs/bin:$PATH
/usr/local/bin/librarian-puppet install
sudo yum clean all

# Puppet facter
var=$(ec2-metadata | grep security-groups | awk '{ print $2 }')
var2="role=$var"
ROLE=$(/opt/puppetlabs/bin/facter $var)
mkdir -p /etc/facter/facts.d
cat > /etc/facter/facts.d/gcp.txt <<- EOF
$var2
EOF
chmod -R 700 /etc/facter/

# Puppet apply
echo "Run puppet apply"
/opt/puppetlabs/bin/puppet apply -d --hiera_config=/opt/cicd/puppet/hiera.yaml --modulepath=/opt/cicd/puppet/localmodules/:/opt/cicd/puppet/modules/  /opt/cicd/puppet/manifests/site.pp -l /var/log/puppet.log
echo "End puppet apply"

# Copy jobs / configs

cp -rf /opt/cicd/jenkins/jobs/* /var/lib/jenkins/jobs/
cp -rf /opt/cicd/jenkins/configs/* /var/lib/jenkins/
chown jenkins:jenkins -R /var/lib/jenkins
systemctl restart jenkins