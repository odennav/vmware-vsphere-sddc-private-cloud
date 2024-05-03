variable "datacenter" {
  default = "odennav-datacenter"
}

variable "username" {
  default = "root"
}

variable "esxi03_passwd" {
  default = "**********"
}

data "vsphere_host_thumbprint" "thumbprint_esxi03" {
  address  = "esxi03.localdomain"
  insecure = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}