output "tag_category_id" {
  description = "vSphere category tag"
  value = module.vsphere_tag_category.category.id
}

output "tag_id" {
  description = "vSphere tag"
  value = module.vsphere_tag.tag.id
}