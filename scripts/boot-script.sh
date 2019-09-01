#!/bin/bash
## Disable SeLinux
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
setenforce 0
## Update all packages
sudo yum -y update
sudo yum install -y epel-release
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo yum install -y python-pip
sudo pip install docker-compose
sudo yum upgrade -y python*
sudo yum clean all

## Copy jobs / configs
# cp -rf /opt/cicd/docker/jenkins/* /var/lib/jenkins/
# chown jenkins:jenkins -R /var/lib/jenkins

## Configure Jenkins
# MAC=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
# SUBNET_ID=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/$MAC\subnet-id)
# sed -i "s/subnet-id/$SUBNET_ID/g" /var/lib/jenkins/config.xml

