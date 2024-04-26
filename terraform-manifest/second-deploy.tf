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


resource "vsphere_compute_cluster" "compute_cluster" {
  name            = "odennav-dc-cluster"
  datacenter_id   = data.vsphere_datacenter.datacenter.id
  ha_enabled      = true # Enable HA
  }


resource "vsphere_datastore_cluster" "datastore_cluster" {
  name            = "odennav-datastore-cluster"
  datacenter_id   = data.vsphere_datacenter.datacenter.id
  sdrs_enabled    = true
  }
