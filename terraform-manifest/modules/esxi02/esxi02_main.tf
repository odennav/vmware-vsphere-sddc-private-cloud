terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}

resource "vsphere_host" "esx-02" {
  hostname   = "192.168.*.*"
  username   = var.username
  password   = var.esxi02_passwd
  thumbprint = data.vsphere_host_thumbprint.thumbprint_esxi02.id
  datacenter = data.vsphere_datacenter.datacenter.id
  

    # Add dependency on vsphere_datacenter
  depends_on = [vsphere_datacenter.prod_datacenter]
}

