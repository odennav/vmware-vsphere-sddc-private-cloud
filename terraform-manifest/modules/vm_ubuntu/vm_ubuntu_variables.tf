variable "datacenter" {
  default = "odennav-datacenter"
}

variable "cluster" {
  default = "odennav-dc-cluster"
}

variable "computer_prefix" {
    type = string
    default = "ubuntu-server"
}

variable "instance_count" {
    default = "2"
}

variable "hosts" {
  default = [
    "192.168.36.3",
    "192.168.36.4",
    "192.168.36.5"
  ]
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
    name = var.cluster
    datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_network" "network" {
    name = "VM Network"
    datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_virtual_machine" "template" {
    name = "packer_ubuntu20"
    datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_host" "host" {
  count         = "${length(var.hosts)}"
  name          = "${var.hosts[count.index]}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
  
}