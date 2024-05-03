terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}

resource "vsphere_virtual_machine" "windows" {
    wait_for_guest_net_timeout = 45
    count = var.instance_count
    name = "${var.computer_win_prefix}0${count.index + 1}"
    resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
    datacenter_id = "${data.vsphere_datacenter.datacenter}"
    datastore_cluster_id = "${vsphere_datastore_cluster.datastore_cluster.id}"
    host_system_id = "${data.vsphere_host.host[2].id}"

    num_cpus = 1
    memory = 2048
    guest_id = "${data.vsphere_virtual_machine.win_template.guest_id}"
    scsi_type = "${data.vsphere_virtual_machine.win_template.scsi_type}"

    enable_logging = true

    network_interface {
      network_id = "${data.vsphere_network.network.id}"
      adapter_type = "${data.vsphere_virtual_machine.win_template.network_interface_types[0]}"
    }

    disk {
        datastore_id = "${vsphere_nas_datastore.nfs_datastore1.id}"
        label = "disk1"
        size = "${data.vsphere_virtual_machine.win_template.disks.0.size}"
        eagerly_scrub = "${data.vsphere_virtual_machine.win_template.disks.0.eagerly_scrub}"
        thin_provisioned = "${data.vsphere_virtual_machine.win_template.disks.0.thin_provisioned}"
    }

    clone {
        template_uuid = "${data.vsphere_virtual_machine.template.id}"

        customize {
          timeout = 0
          windows_options {
              computer_name = "windows01"
          }

          network_interface {
          }
        }
    }
    
    tags = ["${vsphere_tag.tag.id}"]  
}

resource "local_file" "windows_servers_inventory" {
    content = templatefile("../artifacts/hosts_windows.tpl",
    {
        windows_servers_ip = vsphere_virtual_machine.windows.*.default_ip_address
    })
    filename = "../windows.inventory"
}