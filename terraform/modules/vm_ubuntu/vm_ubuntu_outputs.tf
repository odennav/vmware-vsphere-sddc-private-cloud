output "ubuntu_details" {
    value = "${formatlist("%v - %v", vsphere_virtual_machine.ubuntu.*.default_ip_address, vsphere_virtual_machine.ubuntu.*.name)}"
}