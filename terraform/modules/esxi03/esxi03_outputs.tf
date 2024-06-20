output "esxi03_id" {
  description = "3rd ESXi host added to vSphere datacenter"
  value = module.vsphere_host.esx-03.id
}