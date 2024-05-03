variable "datacenter" {
  default = "odennav-datacenter"
}

variable "hosts" {
  default = [
    "192.168.*.*",
    "192.168.*.*",
    "192.168.*.*"
  ]
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_host" "host" {
  count         = "${length(var.hosts)}"
  name          = "${var.hosts[count.index]}"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
  
}

