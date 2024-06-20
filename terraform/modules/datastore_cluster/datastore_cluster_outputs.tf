output "datastore_cluster_id" {
  description = "The datastore cluster created"
  value = module.vsphere_datastore_cluster.datastore_cluster.id
}
