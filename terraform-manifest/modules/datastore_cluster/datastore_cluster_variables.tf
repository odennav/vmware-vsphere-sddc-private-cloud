variable "datacenter" {
  default = "odennav-datacenter"
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}