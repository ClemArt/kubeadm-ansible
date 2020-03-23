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
| python        | Provision python3 and pip3 in the ansible vm                                                                                   |
| ansible_local | Run ansible-playbook with the ansible VM to provision the cluster                                                              |

# Addons
## Metrics
See [metrics-server](./metrics-server/README.md)

## Dashboard
See [Dashboard](./dashboard/README.md)

