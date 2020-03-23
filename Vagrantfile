# -*- mode: ruby -*-
# vi: set ft=ruby :

# Configurations
NB_MASTER = 1
NB_WORKER = 2
ANSIBLE_INVENTORY = "local"

ipPrefix = "172.16.10"
nbMachines = NB_MASTER + NB_WORKER

Vagrant.configure("2") do |config|

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.include_offline = true

  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  config.vm.provision "upgrade", type: "shell", inline: <<-EOF
    apt update
    apt upgrade -y
  EOF

  (1..nbMachines).each do |i|
    config.vm.define "k8s-#{i}" do |v|
      v.vm.hostname = "k8s-#{i}"
      v.vm.synced_folder ".", "/vagrant", mount_options: ["fmode=600", "dmode=755"]

      ip = "#{ipPrefix}.#{100 + i}"
      v.vm.network "private_network", ip: ip
    end
  end

  config.vm.define "ansible" do |v|

    v.vm.hostname = "ansible"
    v.vm.network "private_network", ip: "#{ipPrefix}.100"

    v.vm.synced_folder ".", "/vagrant", mount_options: ["fmode=600", "dmode=755"]

    v.vm.provision "python", type: "shell", inline: <<-EOF
      apt install -y python3 python3-pip
      which pip || ln -s $(which pip3) /usr/bin/pip
    EOF

    v.vm.provision "ansible_local" do |ansible|
      ansible.limit = "all,localhost"
      ansible.install_mode = "pip_args_only"
      ansible.pip_args = "-r /vagrant/requirements.txt"
      ansible.playbook = "playbook.yml"
      ansible.verbose = true
      ansible.inventory_path = "inventory/#{ANSIBLE_INVENTORY}/hosts.ini"
    end

    v.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 4
    end
  end
end
