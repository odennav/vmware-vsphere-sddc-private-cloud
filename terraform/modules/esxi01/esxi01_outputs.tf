output "esxi01_id" {
  description = "1st ESXi host added to vSphere datacenter"
  value = module.vsphere_host.esx-01.id
}

