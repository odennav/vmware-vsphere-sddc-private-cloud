variable "datacenter" {
  default = "odennav-datacenter"
}

variable "username" {
  default = "root"
}

variable "esxi04_passwd" {
  default = "**********"
}

data "vsphere_host_thumbprint" "thumbprint_esxi04" {
  address  = "esxi04.localdomain"
  insecure = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}