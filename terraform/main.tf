terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}

module "datacenter" {
  source = "./modules/datacenter"
}

output "datacenter" {
  description = "vSphere datacenter"  
  value = module.datacenter.datacenter_id
}

module "esxi01" {
  source = "./modules/esxi01"
}

output "esxi01" {
  description = "first host"  
  value = module.esxi01.esxi01_id
}

module "esxi02" {
  source = "./modules/esxi02"
}

output "esxi02" {
  description = "second host"  
  value = module.esxi02.esxi02_id
}

module "esxi03" {
  source = "./modules/esxi03"
}

output "esxi03" {
  description = "third host"  
  value = module.esxi03.esxi03_id
}

module "esxi04" {
  source = "./modules/esxi04"
}

output "esxi04" {
  description = "third host"  
  value = module.esxi04.esxi04_id
}

module "datacenter_cluster" {
  source = "./modules/datacenter_cluster"
}

output "datacenter_cluster" {
  description = "datacenter cluster"  
  value = module.datacenter_cluster.datacenter_cluster_id
}

module "datacenter_edge_cluster" {
  source = "./modules/datacenter_edge_cluster"
}

output "datacenter_edge_cluster" {
  description = "datacenter edge cluster"  
  value = module.datacenter_cluster.datacenter_edge_cluster_id
}

module "tags" {
  source = "./modules/tags"
}

output "tags" {
  description = "vSphere inventory tags"  
  value = module.tags.tag_id
}

module "datastore_cluster" {
  source = "./modules/datastore_cluster"
}

output "datastore_cluster" {
  description = "datastore cluster"  
  value = module.datastore_cluster.datastore_cluster_id
}

module "datastores_nfs" {
  source = "./modules/datastores_nfs"
}

output "nfs_datastore1" {
  description = "first nfs datastore"  
  value = module.datastores_nfs.nfs_datastore1_id
}

output "hb_datastore1" {
  description = "first hb datastore"  
  value = module.datastores_nfs.hb_datastore1_id
}

output "nfs_datastore2" {
  description = "second nfs datastore"  
  value = module.datastores_nfs.nfs_datastore2_id
}

output "hb_datastore2" {
  description = "second hb datastore"  
  value = module.datastores_nfs.hb_datastore2_id
}


