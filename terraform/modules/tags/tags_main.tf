terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}

resource "vsphere_tag_category" "category" {
  name        = var.tag_category_name
  cardinality = var.cardinality
  description = "Managed by Odennav"

  associable_types = [
    "VirtualMachine",
    "Datastore",
  ]

    # Add dependency on vsphere_datacenter
  depends_on = [vsphere_datacenter.prod_datacenter]
}

resource "vsphere_tag" "tag" {
  name        = var.tag_name
  category_id = vsphere_tag_category.category.id
  description = "Managed by Odennav"

    # Add dependency on vsphere_datacenter
  depends_on = [vsphere_datacenter.prod_datacenter]
}