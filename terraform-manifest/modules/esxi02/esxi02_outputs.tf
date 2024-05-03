output "esxi02_id" {
  description = "2nd ESXi host added to vSphere datacenter"
  value = module.vsphere_host.esx-02.id
}

