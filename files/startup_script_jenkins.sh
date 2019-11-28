#!/bin/bash
## Disable SeLinux
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
setenforce 0
## Install docker
sudo yum -y update
sudo amazon-linux-extras install -y docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# sudo yum install -y python-pip
# sudo pip install docker-compose
# sudo yum upgrade -y python*
sudo yum clean all
sudo usermod -aG docker $USER
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
$(aws ecr get-login --no-include-email --region us-east-1)
docker build -t cicd-jenkins -f jenkins.dockerfile .
docker tag cicd-jenkins:latest 803808824931.dkr.ecr.us-east-1.amazonaws.com/cicd-jenkins:latest
docker push 803808824931.dkr.ecr.us-east-1.amazonaws.com/cicd-jenkins:latest
docker build -t cicd-sonar-runner -f sonar-runner.dockerfile .
docker tag cicd-sonar-runner:latest 803808824931.dkr.ecr.us-east-1.amazonaws.com/cicd-sonar-runner:latest
docker push 803808824931.dkr.ecr.us-east-1.amazonaws.com/cicd-sonar-runner:latest
/usr/local/bin/docker-compose up -d
## Run docker as service
# cd /opt/cicd/files
# sudo cp cicd.service /etc/systemd/system
# sudo chmod 664 /etc/systemd/system/cicd.service
# sudo systemctl daemon-reload
# sudo systemctl start cicd.service
