#!/bin/bash
## Disable SeLinux
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
setenforce 0
## Update all packages
sudo yum -y update
## Add Puppet repo and install Puppet
sudo rpm -Uvh https://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm
sudo yum -y install puppet-agent
sudo yum install gem -y
sudo gem install librarian-puppet
cd /opt/cicd/puppet/
export PATH=/opt/puppetlabs/bin:$PATH
/usr/local/bin/librarian-puppet install
sudo yum clean all

## Puppet facter
var=$(ec2-metadata | grep security-groups | awk '{ print $2 }')
var2="role=$var"
ROLE=$(/opt/puppetlabs/bin/facter $var)
mkdir -p /etc/facter/facts.d
cat > /etc/facter/facts.d/gcp.txt <<- EOF
$var2
EOF
chmod -R 700 /etc/facter/

## Puppet apply
echo "Run puppet apply"
/opt/puppetlabs/bin/puppet apply -d --hiera_config=/opt/cicd/puppet/hiera.yaml --modulepath=/opt/cicd/puppet/localmodules/:/opt/cicd/puppet/modules/  /opt/cicd/puppet/manifests/site.pp -l /var/log/puppet.log
echo "End puppet apply"

## MySql
sudo yum install -y wget
sudo wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
sudo yum install -y mysql-server expect
sudo systemctl start mysqld
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
sudo yum remove -y expect

# CREATE DATABASE sonarqube_db;
# CREATE USER 'sonarqube_user'@'localhost' IDENTIFIED BY 'password';
# GRANT ALL PRIVILEGES ON sonarqube_db.* TO 'sonarqube_user'@'localhost' IDENTIFIED BY 'password';
# FLUSH PRIVILEGES;

mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE sonarqube_db;"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER 'sonarqube_user'@'localhost' IDENTIFIED BY 'password';"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON sonarqube_db.* TO 'sonarqube_user'@'localhost' IDENTIFIED BY 'password';"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'sonarqube_user'@'localhost' WITH GRANT OPTION;"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "CREATE USER 'sonarqube_user'@'%' IDENTIFIED BY 'password';"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'sonarqube_user'@'%' WITH GRANT OPTION;"
mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

## Copy jobs / configs
cp -rf /opt/cicd/jenkins/jobs/* /var/lib/jenkins/jobs/
cp -rf /opt/cicd/jenkins/configs/* /var/lib/jenkins/
chown jenkins:jenkins -R /var/lib/jenkins

## Configure Jenkins
MAC=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNET_ID=$(curl http://169.254.169.254/latest/meta-data/network/interfaces/macs/$MAC\subnet-id)
sed -i "s/subnet-id/$SUBNET_ID/g" /var/lib/jenkins/config.xml
systemctl restart jenkins

## EBS mount requirements
echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee --append /etc/sudoers > /dev/null 

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