terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}

resource "vsphere_host" "esx-01" {
  hostname   = "192.168.*.*"
  username   = var.username
  password   = var.esxi01_passwd
  thumbprint = data.vsphere_host_thumbprint.thumbprint_esxi01.id
  datacenter = data.vsphere_datacenter.datacenter.id


    # Add dependency on vsphere_datacenter
  depends_on = [vsphere_datacenter.prod_datacenter]
}


