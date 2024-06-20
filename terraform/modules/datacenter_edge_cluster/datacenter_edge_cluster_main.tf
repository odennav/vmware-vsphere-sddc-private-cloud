terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}


resource "vsphere_compute_cluster" "compute_cluster" {
  name            = "odennav-edge-cluster"
  datacenter_id = data.vsphere_datacenter.datacenter.id
  host_system_ids = data.vsphere_host.host.*.id

  drs_enabled             = true
  drs_automation_level    = "fullyAutomated"
  drs_migration_threshold = 4

  dpm_enabled          = true
  dpm_automation_level = "automated"


  ha_enabled             = true
  ha_host_monitoring     = "enabled"
  ha_vm_restart_priority = "high"

  ha_heartbeat_datastore_policy = "allFeasibleDsWithUserPreference"
  ha_heartbeat_datastore_ids = [vsphere_nas_datastore.hb_datastore1.id, vsphere_nas_datastore.hb_datastore2.id]

    # Add dependency on vsphere_datacenter
  depends_on = [vsphere_datacenter.prod_datacenter]
}