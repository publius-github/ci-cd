#!/bin/bash

## Disable SeLinux
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
setenforce 0

## Install docker
sudo yum -y update
sudo amazon-linux-extras install -y docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo yum install -y python-pip
sudo pip install docker-compose
sudo yum upgrade -y python*
sudo yum clean all

## Mount EBS
fs=$(sudo file -s /dev/xvdh | grep filesystem -c)
if [ $fs -eq "1" ]
then
    echo "[i] FS is exist."
else
    echo "[i] Creating filesystem..."
    sudo mkfs -t xfs /dev/xvdh
fi
sudo mkdir -p /data
sudo chmod 755 /data
sudo mount /dev/xvdh /data
uid=$(sudo blkid | sed -n '/xvdh/s/.*UUID=\"\([^\"]*\)\".*/\1/p')
echo "UUID=$uid  /data  xfs  defaults,nofail  0  2" | sudo tee --append /etc/fstab > /dev/null

## Copy jobs / configs
mkdir -p /data/postgres/postgresql
mkdir -p /data/postgres/postgresql_data
mkdir -p /data/sonarqube/conf
mkdir -p /data/sonarqube/data
mkdir -p /data/sonarqube/extensions
mkdir -p /data/sonarqube/logs
mkdir -p /data/jenkins/jenkins_home
mkdir -p /data/docker
cp -rf /opt/cicd/jenkins/* /data/jenkins/jenkins_home
cp -rf /opt/cicd/docker/* /data/docker/

## Configure Jenkins
MAC=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/$MAC\subnet-id)
sed -i "s/subnet-id/$SUBNET_ID/g" /data/jenkins/jenkins_home/config.xml

## Run docker
cd /data/docker
sudo docker build -t cicd-jenkins -f jenkins.dockerfile .
sudo docker-compose up -d

## Run docker as service
cp cicd.service /etc/systemd/system
chmod 664 /etc/systemd/system/cicd.service
systemctl daemon-reload
systemctl start cicd.service 
#systemctl status cicd.service
