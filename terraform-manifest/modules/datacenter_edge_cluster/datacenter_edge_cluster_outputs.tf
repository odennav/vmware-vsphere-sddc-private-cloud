output "datacenter_edge_cluster_id" {
  description = "The vSphere datacenter edge cluster"
  value = module.vsphere_compute_cluster.compute_cluster.id
}