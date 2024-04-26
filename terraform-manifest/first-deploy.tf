provider "vsphere" {
  user                 = administrator@odennav.local
  password             = **********
  vsphere_server       = vcenter.odennav.local
  allow_unverified_ssl = true
}

variable "datacenter" {
  default = "odennav-dc"
}

variable "hosts" {
  default = [
    "esxi01.localdomain",
    "esxi02.localdomain",
    "esxi03.localdomain",
  ]
}


data "vsphere_host" "host" {
  count         = length(var.hosts)
  name          = var.hosts[count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


resource "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

resource "vsphere_compute_cluster" "compute_cluster" {
  name            = "odennav-dc-cluster"
  datacenter_id   = data.vsphere_datacenter.datacenter.id
  host_system_ids = [data.vsphere_host.host.*.id]

  drs_enabled          = true
  drs_automation_level = "fullyAutomated"

  ha_enabled = false # Initially disable HA

  vsan_enabled = true
  vsan_dedup_enabled = true
  vsan_compression_enabled = true
  vsan_performance_enabled = true
  vsan_verbose_mode_enabled = true
  vsan_network_diagnostic_mode_enabled = true
  vsan_dit_encryption_enabled = true
  vsan_dit_rekey_interval = 1800
  }


