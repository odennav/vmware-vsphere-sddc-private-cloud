variable "datacenter" {
  default = "odennav-datacenter"
}

variable "username" {
  default = "root"
}

variable "esxi02_passwd" {
  default = "**********"
}

data "vsphere_host_thumbprint" "thumbprint_esxi02" {
  address  = "esxi02.localdomain"
  insecure = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}