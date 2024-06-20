terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}

resource "vsphere_nas_datastore" "nfs_datastore1" {
  name                 = "nfs-datastore-1"
  host_system_ids      = ["${data.vsphere_host.esxi_hosts.*.id}"]
  datastore_cluster_id = "${vsphere_datastore_cluster.datastore_cluster.id}"

  type         = "NFS"
  remote_hosts = ["192.168.*.*"]
  remote_path  = "/nfs-share-1"

  depends_on = [vsphere_datastore_cluster.datastore_cluster]
}

resource "vsphere_nas_datastore" "hb_datastore1" {
  name                 = "heartbeat-datastore-1"
  host_system_ids      = ["${data.vsphere_host.esxi_hosts.*.id}"]
  datastore_cluster_id = "${vsphere_datastore_cluster.datastore_cluster.id}"

  type         = "NFS"
  remote_hosts = ["192.168.*.*"]
  remote_path  = "/hb-share-1"

  depends_on = [vsphere_datastore_cluster.datastore_cluster]
}


resource "vsphere_nas_datastore" "nfs_datastore2" {
  name                 = "nfs-datastore-2"
  host_system_ids      = ["${data.vsphere_host.esxi_hosts.*.id}"]
  datastore_cluster_id = "${vsphere_datastore_cluster.datastore_cluster.id}"

  type         = "NFS"
  remote_hosts = ["192.168.*.*"]
  remote_path  = "/nfs-share-2"

  depends_on = [vsphere_datastore_cluster.datastore_cluster]
}

resource "vsphere_nas_datastore" "hb_datastore2" {
  name                 = "heartbeat-datastore-1"
  host_system_ids      = ["${data.vsphere_host.esxi_hosts.*.id}"]
  datastore_cluster_id = "${vsphere_datastore_cluster.datastore_cluster.id}"

  type         = "NFS"
  remote_hosts = ["192.168.*.*"]
  remote_path  = "/hb-share-2"

  depends_on = [vsphere_datastore_cluster.datastore_cluster]
}
