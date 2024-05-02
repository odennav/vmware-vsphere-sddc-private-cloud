variable "vcenter_username" {
    type = string
    default = "vcenter"
    sensitive = true
}

variable "vcenter_password" {
    type = string
    default = "**********"
    sensitive = true
}

variable "vcenter_server" {
    type = string
    default = "vcenter.odennav.local"
    sensitive = true
}

variable "vcenter_cluster" {
    type = string
    default = "odennav-dc-cluster"
    sensitive = true
}

variable "vcenter_datacenter" {
    type = string
    default = "odennav-dc"
    sensitive = true
}

variable "esx_datastore" {
    type = string
    default = "odennav-datastore-cluster"
    sensitive = true
}



locals {
    buildtime = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
}

source "vsphere-iso" "windows2019" {
    vcenter_server = var.vcenter_server
    username = var.vcenter_username
    password = var.vcenter_password
    cluster = var.vcenter_cluster
    datacenter = var.vcenter_datacenter
    datastore = var.esx_datastore
    folder ="Templates"
    insecure_connection = "true"

    notes = "Built by Packer on ${local.buildtime}"
    vm_name = "packer_windows2019"
    winrm_username = "Administrator"
    winrm_password = "S3cret!"
    CPUs = "1"
    RAM = "4096"
    RAM_reserve_all = true
    communicator = "winrm"
    disk_controller_type = ["lsilogic-sas"]
    firmware = "bios"
    floppy_files = [
        "artifacts/autounattend.xml",
        "artifacts/setup.ps1",
        "artifacts/winrm.bat",
        "artifacts/vmtools.cmd"
    ]
    guest_os_type = "windows9Server64Guest"
    iso_paths = [
        "[${var.esx_datastore}] ISO/SERV2019.ENU.JAN2021.iso",
        "[] /vmimages/tools-isoimages/windows.iso"
    ]

    network_adapters {
        network = "VM Network"
        network_card = "vmxnet3"
    }

    storage {
        disk_size = "40960"
        disk_thin_provisioned = true
    }

    convert_to_template = true

    http_port_max = 8600
    http_port_min = 8600
}

build {
    sources = ["source.vsphere-iso.windows2019"]
}