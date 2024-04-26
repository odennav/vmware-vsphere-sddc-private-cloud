
provider "vsphere" {
  user                 = administrator@odennav.local
  password             = **********
  vsphere_server       = vcenter.odennav.local
  allow_unverified_ssl = true
}

variable "datacenter" {
  default = "odennav-dc"
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

variable "datastore" {
  default = "odennav-datastore-cluster"
}

data "vsphere_datastore" "datastore" {
    name = var.datastore
    datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

variable "cluster" {
  default = "odennav-dc-cluster"
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
    name = "packer_windows2019"
    datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

variable "computer_prefix" {
    type = string
    default = "windows-server"
}

variable "instance_count" {
    default = "2"
}

resource "vsphere_virtual_machine" "windows" {
    wait_for_guest_net_timeout = 45
    count = var.instance_count
    name = "${var.computer_prefix}0${count.index + 1}"
    resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
    datastore_id = "${data.vsphere_datastore.datastore.id}"

    num_cpus = 1
    memory = 2048
    guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
    scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

    enable_logging = true

    network_interface {
      network_id = "${data.vsphere_network.network.id}"
      adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
    }

    disk {
        datastore_id = "${data.vsphere_datastore.datastore.id}"
        label = "disk1"
        size = "${data.vsphere_virtual_machine.template.disks.0.size}"
        eagerly_scrub = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
        thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    }

    clone {
        template_uuid = "${data.vsphere_virtual_machine.template.id}"

        customize {
          timeout = 0
          windows_options {
              computer_name = "windows01"
          }

          network_interface {
          }
        }
    }
}

output "final" {
    value = "${formatlist("%v - %v", vsphere_virtual_machine.windows.*.default_ip_address, vsphere_virtual_machine.windows.*.name)}"
}