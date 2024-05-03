# vSphere datacenter outputs

output "datacenter_id" {
  description = "The vSphere datacenter"
  value = module.vsphere_datacenter.prod_datacenter.moid
}

