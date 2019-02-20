Vagrant.configure("2") do |config|

    config.vm.box = "centos/7"
    # config.vm.synced_folder "./jenkins", "/opt/jenkins"   
    config.vm.network "public_network", bridge: "ExternalVirtualSwitch"
    config.vm.network "forwarded_port", guest: 22, host: 2222
    config.vm.network "forwarded_port", guest: 8080, host: 8080
  
    config.vm.provider "hyperv" do |h|
      h.memory = "2000"
      h.cpus = "2"
    end
  
    # config.vm.define "web" do |web|
    #   web.vm.box = "centos/7"
    #   web.vm.hostname = "web"
    # end
  
    # config.vm.define "db" do |db|
    #   db.vm.box = "centos/7"
    #   db.vm.hostname = "db"
    # end

    config.vm.define "jenkins" do |jenkins|
        jenkins.vm.box = "centos/7"
        jenkins.vm.hostname = "jenkins"
    end

    config.vm.provision "shell", inline: <<-SHELL
        setenforce 0
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        yum update -y
        yum upgrade -y
        yum -y install epel-release wget unzip nano vim net-tools iptables-services
        yum remove firewalld -y
        sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/g' /etc/ssh/sshd_config
        sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
        systemctl restart sshd
    SHELL

    config.vm.provision "shell",
        path: "./jenkins/master/startup-jenkins-master.sh"

end
  
    # config.vm.provision "ansible" do |ansible|
    #     ansible.playbook = 'ansible/provision.yml'
    #     ansible.verbose = 'vv'
    # end

    # config.vm.provision "puppet" do |puppet|
    #     puppet.working_directory = "/tmp/vagrant-puppet/"
    #     puppet.hiera_config_path = "puppet/vagrant_hiera.yaml"
    #     puppet.manifests_path = "puppet/manifests"
    #     puppet.manifest_file = "site.pp"
    #     puppet.module_path = ["puppet/modules", "puppet/localmodules"]
    #     puppet.facter = {
    #       "role" => node_config['role']
    #     }
    # end