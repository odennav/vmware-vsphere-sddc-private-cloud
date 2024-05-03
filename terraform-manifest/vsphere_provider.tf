provider "vsphere" {
  user                 = var.user
  password             = var.password
  vsphere_server       = var.vcenter
  allow_unverified_ssl = true
}

