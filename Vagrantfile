# -*- mode: ruby -*-
# vi: set ft=ruby :

NB_MASTER = 3
NB_WORKER = 0

nbMachines = NB_MASTER + NB_WORKER
machinesIPs = (0..nbMachines).collect {|i| "172.16.10.#{100 + i}"}
machinesIPsString = machinesIPs.join(",")

Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "#{ENV['HTTP_PROXY']}"
    config.proxy.https    = "#{ENV['HTTP_PROXY']}"
    config.proxy.no_proxy = "#{ENV['NO_PROXY']},#{machinesIPsString}"
  end

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = false
  config.hostmanager.manage_guest = true
  config.hostmanager.include_offline = true

  config.vm.box = "generic/centos7"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  if Vagrant.has_plugin?("vagrant-proxyconf") && Dir.exists?("./ssl")
    config.vm.provision "custom_ssl", type: "shell", inline: <<-EOF
      cp /vagrant/ssl/*.pem /etc/pki/ca-trust/source/anchors/
      update-ca-trust
    EOF
  end

  config.vm.provision "upgrade", type: "shell", inline: <<-EOF
    yum upgrade -y
  EOF

  (1..nbMachines).each do |i|
    config.vm.define "k8s-#{i}" do |v|
      v.vm.hostname = "k8s-#{i}"
      v.vm.synced_folder ".", "/vagrant", mount_options: ["fmode=600", "dmode=755"]

      ip = "172.16.10.#{100 + i}"
      v.vm.network "private_network", ip: ip
    end
  end

  config.vm.define "ansible" do |v|
    v.vm.hostname = "ansible"
    v.vm.network "private_network", ip: "172.16.10.100"

    v.vm.synced_folder ".", "/vagrant", mount_options: ["fmode=600", "dmode=755"]

    v.vm.provision "python", type: "shell", inline: <<-EOF
      yum install -y python3 python3-pip
      which pip || ln -s $(which pip3) /usr/bin/pip
    EOF

    v.vm.provision "ansible_local" do |ansible|
      ansible.limit = "all"
      ansible.install_mode = "pip_args_only"
      ansible.pip_args = "-r /vagrant/requirements.txt"
      ansible.playbook = "playbook.yml"
      ansible.verbose = true
      ansible.inventory_path = "inventory/sample/hosts.ini"
    end
  end
end
