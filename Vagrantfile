Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.synced_folder "puppet/", "/tmp/vagrant-puppet/"
  config.vm.network "public_network", bridge: "Default Switch"
  config.vm.network "forwarded_port", guest: 22, host: 2222

  #Jenkins 
  config.vm.network "forwarded_port", guest: 8080, host: 9080
  config.vm.network "forwarded_port", guest: 50000, host: 50000
  config.vm.network "forwarded_port", guest: 9000, host: 9000
  config.vm.hostname = "jenkins"
  config.puppet_install.puppet_version = "5.5.10"
  # config.puppet_install.puppet_version = :latest

  config.vm.provider "hyperv" do |h|
    h.memory = "4000"
    h.cpus = "2"
  end

  config.vm.provision "file", source: "jenkins/.", destination: "/tmp/vagrant-jenkins"

  config.vm.provision "puppet" do |puppet|
    puppet.working_directory = "/tmp/vagrant-puppet/"
    puppet.hiera_config_path = "puppet/hiera.yaml"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = ["puppet/modules", "puppet/localmodules"]
    puppet.facter = {
      "role" => 'jenkins'
    }
  end

  config.vm.provision "shell", inline: <<-SHELL
    chmod 777 -R /tmp/vagrant-puppet/
    cd /tmp/vagrant-puppet/
    yum install gem -y
    gem install librarian-puppet
    cd /tmp/vagrant-puppet/
    /usr/local/bin/librarian-puppet install
    puppet apply -d --hiera_config=/tmp/vagrant-puppet/hiera.yaml --modulepath=/tmp/vagrant-puppet/localmodules/:/tmp/vagrant-puppet/modules/  /tmp/vagrant-puppet/manifests/site.pp
  SHELL

  config.vm.provision "shell", path: "vagrant/00-vg-sonar.sh"
  config.vm.provision "shell", path: "vagrant/01-vg-docker.sh"
  config.vm.provision "shell", path: "vagrant/02-vg-dotnet.sh"
  config.vm.provision "shell", path: "vagrant/03-vg-copy-jobs.sh"

  config.vm.provision "shell", inline: <<-SHELL
    hostname -I | awk '{print $1}'
  SHELL
end
