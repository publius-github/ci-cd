Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "jenkins"

  config.vm.provider "hyperv" do |h|
    h.memory = "6000"
    h.cpus = "4"
  end

  config.vm.synced_folder "docker/", "/tmp/vagrant-docker/"
  config.vm.synced_folder "vagrant/", "/tmp/vagrant-docker-endpoint"

  config.vm.network "public_network", bridge: "Default Switch"
  config.vm.network "forwarded_port", guest: 22, host: 2222
  # Jenkins 
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 50000, host: 50000
  # Sonarqube
  config.vm.network "forwarded_port", guest: 9000, host: 9000

  # Pre-configure
  config.vm.provision "shell", inline: <<-SHELL
    yum install -y wget unzip
  SHELL

  # Docker / Docker-compose
  config.vm.provision "shell", inline: <<-SHELL
    yum install -y epel-release
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce
    systemctl enable docker.service
    systemctl start docker.service
    yum install -y python-pip
    pip install docker-compose
    yum upgrade -y python*
    usermod -aG docker vagrant
  SHELL

  # Start apps
  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p /data/postgres/postgresql
    mkdir -p /data/postgres/postgresql_data
    mkdir -p /data/sonarqube/sonarqube_conf
    mkdir -p /data/sonarqube/sonarqube_data
    mkdir -p /data/sonarqube/sonarqube_extensions
    mkdir -p /data/sonarqube/sonarqube_bundled-plugins 
    mkdir -p /data/jenkins/jenkins_home
    cp -rf /tmp/vagrant-docker/jenkins/* /data/jenkins/jenkins_home
    cd /tmp/vagrant-docker/
    docker build -f jenkins.dockerfile -t cicd-jenkins .
    cd /tmp/vagrant-docker-endpoint
    docker-compose up -d
  SHELL

end
