terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}

resource "vsphere_datastore_cluster" "datastore_cluster" {
  name          = "odennav-datastore-cluster"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"

  sdrs_enabled                           = true
  sdrs_automation_level                  = "automated"
  sdrs_free_space_threshold              = 10
  sdrs_free_space_utilization_difference = 10

    # Add dependency on vsphere_datacenter
  depends_on = [vsphere_datacenter.prod_datacenter]
}

