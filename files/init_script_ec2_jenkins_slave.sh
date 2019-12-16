#!/bin/bash
sudo yum -y install git maven java-1.8.0-openjdk-devel wget unzip jq
sudo amazon-linux-extras install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo chmod 777 /var/run/docker.sock
sudo curl -L "https://github.com/docker/compose/releases/download/1.17.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo wget https://releases.hashicorp.com/terraform/0.12.8/terraform_0.12.8_linux_amd64.zip
sudo unzip terraform_0.12.8_linux_amd64.zip
sudo mv terraform /usr/local/bin
sudo rm -f terraform_0.12.8_linux_amd64.zip
sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
sudo yum -y install dotnet-sdk-2.2
sudo curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum -y install nodejs
sudo wget http://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip -O /tmp/chromedriver_linux64.zip
sudo unzip -o /tmp/chromedriver_linux64.zip -d /tmp
sudo mv /tmp/chromedriver /usr/bin/chromedriver
sudo curl https://intoli.com/install-google-chrome.sh | bash
sudo mv /usr/bin/google-chrome-stable /usr/bin/google-chrome
