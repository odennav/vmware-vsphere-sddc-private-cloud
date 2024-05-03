output "datacenter_cluster_id" {
  description = "The vSphere datacenter cluster"
  value = module.vsphere_compute_cluster.compute_cluster.id
}