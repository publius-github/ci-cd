sudo yum -y install git maven java-1.8.0-openjdk-devel yum-utils device-mapper-persistent-data lvm2 wget unzip
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y http://ftp.riken.jp/Linux/cern/centos/7/extras/x86_64/Packages/container-selinux-2.9-4.el7.noarch.rpm
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo chmod 777 /var/run/docker.sock
sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
sudo yum -y install dotnet-sdk-2.2
sudo wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
sudo unzip terraform_0.11.13_linux_amd64.zip
sudo mv terraform /usr/local/bin
sudo rm -f terraform_0.11.13_linux_amd64.zip
sudo useradd sonarqube
cd /opt
sudo wget  https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.6.zip
sudo unzip sonarqube-7.6.zip
sudo rm -rf sonarqube-7.6.zip
sudo cp -rf sonarqube-7.6 sonarqube
sudo rm -rf sonarqube-7.6
sudo chown sonarqube. /opt/sonarqube -R
echo "sonar.jdbc.username=sonarqube_user" | sudo tee --append /opt/sonarqube/conf/sonar.properties
echo "sonar.jdbc.password=password" | sudo tee --append /opt/sonarqube/conf/sonar.properties
echo "sonar.jdbc.url=jdbc:mysql://10.0.1.100:3306/sonarqube_db?useUnicode=true&amp;characterEncoding=utf8&amp;rewriteBatchedStatements=true&amp;useConfigs=maxPerformance" | sudo tee --append /opt/sonarqube/conf/sonar.properties
sudo sed -i "s/#RUN_AS_USER=/RUN_AS_USER=sonarqube/" /opt/sonarqube/bin/linux-x86-64/sonar.sh
touch /tmp/sonar.service
echo "[Unit]" >> /tmp/sonar.service
echo "Description=SonarQube service" >> /tmp/sonar.service
echo "After=syslog.target network.target" >> /tmp/sonar.service
echo "[Service]" >> /tmp/sonar.service
echo "Type=forking" >> /tmp/sonar.service
echo "ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start" >> /tmp/sonar.service
echo "ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop" >> /tmp/sonar.service
echo "User=sonarqube" >> /tmp/sonar.service
echo "Group=sonarqube" >> /tmp/sonar.service
echo "Restart=always" >> /tmp/sonar.service
echo "[Install]" >> /tmp/sonar.service
echo "WantedBy=multi-user.target" >> /tmp/sonar.service
sudo cp -f /tmp/sonar.service /etc/systemd/system/
sudo rm -f /tmp/sonar.service
sudo systemctl enable sonar
sudo systemctl start sonar
cd /opt
sudo wget http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip
sudo unzip sonar-runner-dist-2.4.zip
sudo mv sonar-runner-2.4 sonar-runner
sudo rm -rf sonar-runner-dist-2.4.zip
