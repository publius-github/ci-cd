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

## DOCKER ### 

# sudo yum install -y yum-utils device-mapper-persistent-data lvm2
# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# yum install -y docker-ce docker-ce-cli containerd.io
# systemctl enable docker
# systemctl start docker

## JENKINS 

curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum install -y jenkins
# sudo cp -rf /opt/jenkins/jenkins_home/* /var/lib/jenkins/
# sed -i 's/JENKINS_ARGS=""/JENKINS_ARGS="-Djenkins.install.runSetupWizard=false"/' /etc/sysconfig/jenkins
# usermod -a -G docker jenkins
systemctl enable jenkins

systemctl start jenkins

## MYSQL

wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum install mysql-server -y
systemctl start mysqld

export MYSQL_ROOT_PASSWORD="password"

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Set root password?\"
send \"y\r\"
expect \"New password:\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Re-enter new password:\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
echo "$SECURE_MYSQL"
yum remove -y expect

# CREATE DATABASE sonarqube_db;
# CREATE USER 'sonarqube_user'@'localhost' IDENTIFIED BY 'password';
# GRANT ALL PRIVILEGES ON sonarqube_db.* TO 'sonarqube_user'@'localhost' IDENTIFIED BY 'password';
# FLUSH PRIVILEGES;

mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE sonarqube_db;"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER 'sonarqube_user'@'localhost' IDENTIFIED BY 'password';"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON sonarqube_db.* TO 'sonarqube_user'@'localhost' IDENTIFIED BY 'password';"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

## SONARQUBE 

useradd sonarqube

cd /opt
wget  https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.6.zip
sudo unzip sonarqube-7.6.zip
rm -rf sonarqube-7.6.zip
cp -rf sonarqube-7.6 sonarqube
rm -rf sonarqube-7.6

chown sonarqube. /opt/sonarqube -R

echo 'sonar.jdbc.username=sonarqube_user' >> /opt/sonarqube/conf/sonar.properties
echo 'sonar.jdbc.password=password' >> /opt/sonarqube/conf/sonar.properties
echo 'sonar.jdbc.url=jdbc:mysql://localhost:3306/sonarqube_db?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance' >> /opt/sonarqube/conf/sonar.properties
sed -i 's/#RUN_AS_USER=/RUN_AS_USER=sonarqube/' /opt/sonarqube/bin/linux-x86-64/sonar.sh

echo "[Unit]">> /etc/systemd/system/sonar.service
echo "Description=SonarQube service">> /etc/systemd/system/sonar.service
echo "After=syslog.target network.target">> /etc/systemd/system/sonar.service
echo "[Service]">> /etc/systemd/system/sonar.service
echo "Type=forking">> /etc/systemd/system/sonar.service
echo "ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start">> /etc/systemd/system/sonar.service
echo "ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop">> /etc/systemd/system/sonar.service
echo "User=sonarqube">> /etc/systemd/system/sonar.service
echo "Group=sonarqube">> /etc/systemd/system/sonar.service        
echo "Restart=always">> /etc/systemd/system/sonar.service
echo "[Install]">> /etc/systemd/system/sonar.service
echo "WantedBy=multi-user.target">> /etc/systemd/system/sonar.service

systemctl enable sonar
systemctl start sonar

cd /opt
wget http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip
sudo unzip sonar-runner-dist-2.4.zip
mv sonar-runner-dist-2.4.zip sonar-runner
rm -rf sonar-runner-dist-2.4.zip

ip a | grep inet
