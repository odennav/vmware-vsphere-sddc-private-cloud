terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.7.0"
    }
  }
}

resource "vsphere_virtual_machine" "ubuntu" {
    wait_for_guest_net_timeout = 45
    count = var.instance_count
    name = "${var.computer_prefix}0${count.index + 1}"
    resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
    datacenter_id = "${data.vsphere_datacenter.datacenter}"
    datastore_cluster_id = "${vsphere_datastore_cluster.datastore_cluster.id}"
    host_system_id = "${data.vsphere_host.host[0].id}"

    num_cpus = 1
    memory = 2048
    guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
    scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

    enable_logging = true

    network_interface {
      network_id = "${data.vsphere_network.network.id}"
      adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
    }

    disk {
        datastore_id = "${vsphere_nas_datastore.nfs_datastore1.id}"
        label = "disk0"
        size = "${data.vsphere_virtual_machine.template.disks.0.size}"
        eagerly_scrub = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
        thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    }

    clone {
        template_uuid = "${data.vsphere_virtual_machine.template.id}"

        customize {
          timeout = 0
          linux_options {
              host_name = "${var.computer_prefix}0${count.index + 1}"
              domain = "odennav.local"
          }

          network_interface {
          }
        }
    }

    provisioner "file" {
        source = "~/.ssh/id_rsa.pub"
        destination = "/home/ubuntu/id_rsa.pub"

        connection {
            type = "ssh"
            user = "ubuntu"
            password = "ubuntu"
            host = self.default_ip_address
        }
    }

    provisioner "remote-exec" {
        inline = [
            "sudo mkdir -p /home/ubuntu/.ssh",
            "sudo chmod 700 /home/ubuntu/.ssh",
            "sudo touch /home/ubuntu/.ssh/authorized_keys",
            "sudo sh -c 'cat /home/ubuntu/mykey.pub > /home/ubuntu/.ssh/authorized_keys'",
            "sudo chown -R ubuntu: /home/ubuntu/.ssh",
            "sudo chmod -R 644 /home/ubuntu/.ssh/authorized_keys",
            "sudo rm -rf /home/ubuntu/mykey.pub"
        ]

        connection {
            type = "ssh"
            user = "ubuntu"
            password = "ubuntu"
            host = self.default_ip_address
        }
    }

    tags = ["${vsphere_tag.tag.id}"]  
}

resource "local_file" "ubuntu_servers_inventory" {
    content = templatefile("../artifacts/hosts_ubuntu.tpl",
    {
        ubuntu_servers_ip = vsphere_virtual_machine.ubuntu.*.default_ip_address
    })
    filename = "../ubuntu.inventory"
}