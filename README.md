# Kubernetes with kubeadm & Ansible
Creation of a bp cluster based on kubeadm, using Ansible

# Menu
- [Kubernetes with kubeadm & Ansible](#kubernetes-with-kubeadm--ansible)
- [Menu](#menu)
- [TODO list](#todo-list)
- [Component versions](#component-versions)
- [Automated Provisioning](#automated-provisioning)
  - [Ansible VM](#ansible-vm)
  - [Provisioning](#provisioning)
- [Step by Step Provisioning](#step-by-step-provisioning)
- [Addons](#addons)
  - [Metrics](#metrics)
  - [Dashboard](#dashboard)
- [Troubleshoting](#troubleshoting)
  - [Changes to workspace not propagated in VM](#changes-to-workspace-not-propagated-in-vm)
  - [Entreprise proxy](#entreprise-proxy)

# TODO list

* [ ] Join worker nodes
* [ ] Disable swap on reboot
* [x] Use CNI plugin (flannel at first)
* [ ] Add calico for network policies
* [ ] Use other cni plugin
* [ ] Split playbook in smaller parts
* [ ] Create roles
* [ ] Add tests...
* [ ] Use containerd instead of docker (choice by variable) 

# Component versions

* docker v19.03.4
* kubeadm v1.16.2
* Ansible v2.8.6

# Automated Provisioning

## Ansible VM

The ansible VM is used to run the ansible_provisioner on all VMs. While it's more verbose and complex, it provides:

* Isolated ansible environment
* Simulation of a CI-like environment, where a CI runner runs ansible commands for the distant cluster
* Windows support, as ansible runner is not natively supported on windows (though WSL could be an option, but Vagrant does not feet well yet with WSL) 

## Provisioning

Simply run `vagrant up` and watch Ansible do the rest

# Step by Step Provisioning

    vagrant provision --provision-with "provider1,provider2,..."

Each provider is a script with a specific goal (in order of provisioning) :

| name          | actions                                                                                                                        |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| custom_ssl    | Copy the content of the `custom_ssl` folder in working directory to the trusted CA sources of centos, then update the trust CA bundle |
| python        | Provision python3 and pip3 in the ansible vm                                                                                   |
| ansible_local | Run ansible-playbook with the ansible VM to provision the cluster                                                              |

# Addons
## Metrics
See [metrics-server](./metrics-server/README.md)

## Dashboard
See [Dashboard](./dashboard/README.md)

# Troubleshoting

## Changes to workspace not propagated in VM

This can happen if the sync folder is not enabled (by configuration or because the image does not support guest additions).

You can run `vagrant rsync` to resync folders.

## Entreprise proxy

* Install the **vagrant-proxyconf** plugin : https://github.com/tmatilai/vagrant-proxyconf
* Make sure your **HTTP_PROXY**, **HTTPS_PROXY** and **NO_PROXY** environment variables are set with proxy URL
  * Typically

        HTTP_PROXY = http://myproxy.org:port    
        HTTPS_PROXY = http://myproxy.org:port
        NO_PROXY = localhost,127.0.0.1

If your proxy is of type MITM, you should create a `custom_ssl` folder next to the `Vagrantfile` and put the proxy's root CA in here. Make sure the VMs have the current workspace shared as the `/vagrant` folder and reprovision them to upload and trust the CA. See `custom_ssl` provisioner above.