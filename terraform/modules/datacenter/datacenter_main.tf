terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}

# vSphere datacenter created in vCenter environment

resource "vsphere_datacenter" "prod_datacenter" {
  name = var.datacenter
}



