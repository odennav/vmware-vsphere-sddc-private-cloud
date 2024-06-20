output "nfs_datastore1_id" {
  description = "The 1st nfs datastore"
  value = module.vsphere_nas_datastore.nfs_datastore1.id
}

output "hb_datastore1_id" {
  description = "The 1st heartbeat datastore"
  value = module.vsphere_nas_datastore.hb_datastore1.id
}

output "nfs_datastore2_id" {
  description = "The 2nd nfs datastore"
  value = module.vsphere_nas_datastore.nfs_datastore2.id
}

output "hb_datastore2_id" {
  description = "The 2nd heartbeat datastore"
  value = module.vsphere_nas_datastore.hb_datastore2.id
}

