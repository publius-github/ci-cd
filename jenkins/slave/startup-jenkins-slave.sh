#!/bin/bash
sudo su

## PREPARING 
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
yum update -y
yum upgrade -y
yum -y install epel-release wget unzip nano vim net-tools iptables-services
yum remove firewalld -y
sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

yum -y install expect git maven
yum install -y java-1.8.0-openjdk-devel

## DOCKER 

sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker

## JENKINS 

curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum install -y jenkins
#   sudo cp -rf /opt/jenkins/jenkins_home/* /var/lib/jenkins/
systemctl start jenkins
systemctl enable jenkins

usermod -a -G docker jenkins
systemctl restart jenkins

