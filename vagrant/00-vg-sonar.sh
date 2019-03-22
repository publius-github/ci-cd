#!/bin/bash
## MYSQL
yum install -y wget unzip expect
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
mv sonar-runner-2.4 sonar-runner
rm -rf sonar-runner-dist-2.4.zip


