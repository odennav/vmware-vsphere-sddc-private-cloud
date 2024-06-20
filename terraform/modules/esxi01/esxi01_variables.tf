variable "datacenter" {
  default = "odennav-datacenter"
}

variable "username" {
  default = "root"
}

variable "esxi01_passwd" {
  default = "**********"
}

data "vsphere_host_thumbprint" "thumbprint_esxi01" {
  address  = "esxi01.localdomain"
  insecure = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}