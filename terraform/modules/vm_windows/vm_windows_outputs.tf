output "windows_details" {
    value = "${formatlist("%v - %v", vsphere_virtual_machine.windows.*.default_ip_address, vsphere_virtual_machine.windows.*.name)}"
}