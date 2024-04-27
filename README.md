# SDDC VMware Lab

SDDC (Software Defined Data Center) is an architecture that allows for any application's infrastructure to be fully automated and always available.

It's a special kind of data storage and computing facility in which basic components such as CPU, storage, networking, security are all virtualized and delivered as services via smart software.

**Main Components of VMware SDDC**

- Server Virtualization with VMware's vSphere

- Storage Virtualization with VMware vSAN 

- Network Virtualization with VMware NSX

![](https://github.com/odennav/vmware-sddc-private-cloud/blob/main/docs/datacenter.PNG)


The objective of this project is to utilize VMware infrastructure for private cloud hosting solutions in your home lab. 
You'll also find relevant guides on alternative large-scale VMware deployments.

The two core components of vSphere are `ESXi` and `vCenter Server`.

ESXi is the virtualization platform to make virtual machines and virtual appliances.

The vCenter server appliance is a preconfigured virtual machine optimized for running vCenter server and the vCenter server components.
vCenter server is a service that lets you pool and manage the resources of multiple hosts.


-----

# Getting Started

To ensure a successful VMware deployment, note the workflow required:

1. Prepare for ESXi Installation.

2. Install ESXi on Hosts.

3. Configure ESXi on Hosts.

4. Prepare for vCenter Installation.

5. Deploy vCenter Server Appliance.

6. Configure System Logging.

7. Manage vCenter Server Services

8. Enable vSphere vSAN and DRS(Distributed Resource Scheduler)

9. Enable vSphere HA(High Availability) and Storage DRS

10. Provision Windows and Linux VMs to vSphere Cluster



## Prepare for ESXi Installation

Two important steps to implement for preparation are:

1. **Download the ESXi Installer**

Create a [VMware Customer Connect](https://customerconnect.vmware.com/home) account and download `ESXi VMware-VMvisor-Installer`.

2. **Choose option for installing ESXi**

ESXi installations are designed to accommodate a range of deployment sizes.  
The different options available for accessing the installation media and booting the installer:

- Interactive ESXi installation

- [Scripted ESXi installation](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-00224A32-C5C5-4713-969A-C50FF4DED8F8.html)

- [vSphere Auto Deploy ESXi installation](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-DC5D6EA2-2F17-4CB0-A0DB-C767F2BE2FBA.html)

Check this guide [here](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-6E6BCACF-33CA-4466-90B7-73CCA37BB5E1.html)
to thoroughly understand the different ways of deployment.

We'll implement `Interactive ESXi installation` with `VMware Workstation` for small deployment of 3 hosts in this project.


3. **ESXi Requirements**

To install or upgrade ESXi, your system must meet specific hardware and software requirements.


### ESXi Hardware Requirements

To install or upgrade ESXi 7.0, your hardware and system resources must meet the following
requirements:

- Requires a host with at least two CPU cores.

- Supports a broad range of multi-core of 64-bit x86 processors.

- Requires the NX/XD bit to be enabled for the CPU in the BIOS.

- Minimum of 8 GB of physical RAM. Provide at least 8 GB of RAM to run
virtual machines in typical production environments.

- For 64-bit virtual machines, support for hardware virtualization (Intel VT-x or AMD RVI) must be enabled on x64 CPUs.

- Recommended size for VMware ESXi 7.0 is 142GB minimum. VMFS datastore is created automatically to store virtual machine data.
  Local disk of 128 GB or larger for optimal support of ESX-OSData. 
  The disk contains the boot partition, ESX-OSData volume and a VMFS datastore.

- vSphere 7.0 supports booting ESXi hosts from the Unified Extensible Firmware Interface (UEFI). With UEFI, we can boot systems from hard drives, CD-ROM drives, or USB media.
 

For a complete list of supported processors and server platforms, see the VMware compatibility guide at http://www.vmware.com/resources/compatibility.

-----

## Install ESXi on Hosts

### Creating ESXi virtual machine in VMware Workstation

1. Download `VMware Workstation Player 17` [here](https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html)

2. Open your VMware Workstation, click on `Create a New Virtual Machine`

3. Select `Installer disc image file (iso):` and click `Browse...` to find the VMware ESXi iso in your directory. Click `Next`.

4. Name the virtual machine as `ESXi-1` and select `Location` you want the ESXi installed.   Click `Next`.

5. Select `store virtual disk as a single file` and specify disk capacity of 180GB. Click `Next`.

6. Click on `Customize Hardware`, select `Memory` size of 8GB and 4 Processor cores as minimum.
   
   Select `Virtualize Intel VT-x/EPT or AMD-V/RVI`
   
   Use `Bridged` network connection.

7. Select `Power on this virtual machine after creation`.
   
   Click `Finish`.


### Installing ESXi in VMware Workstation

Once your virtual machine is up and running, follow the next steps to finish the ESXi installation on your VMware Workstation.

1. When the `Welcome to the VMware ESXi installation` pops up, press `Enter` to continue.

2. Accept the `End User License Agreement` by hitting the `F11` key.

3. Select the `Local` disk where ESXi will be installed and hit Enter.

4. Choose your keyboard layout and hit Enter.

5. Enter your `Root password`, confirm it and securely store it. Press `Enter`.

6. Confirm the installation by pressing `F11`.

7. Once complete, you must remove the installation media. You can remove it by clicking `I Finished Installing` on the bottom left side of the VMware Workstation window.

After removing your installation media, go back to the virtual machine installation screen and hit `Enter` to reboot. The VM will shutdown and reboot.

-----

## Configure ESXi on Hosts

After the reboot is complete and the ESXi virtual machine is running, note the IP address of the ESXi host server. Dynamic host configuration protocol (DHCP) assigns the IP address the VMware ESXiserver uses when it is initialized. 

You can use the IP address assigned from DHCP, or as an alternative, you can set up a static IP addressof your choice by following these steps.

1. In the running ESXi virtual machine, press `F2`.

2. Enter your `Login Name` as root, type your `Password` and hit Enter.

3. Use the arrow keys to move and select `Configure Management Network` then press Enter.

4. Select `IPv4 Configuration` and hit Enter.

5. Using the arrow keys, highlight `Set static IPv4 address and network configuration` and press the Space key to select it.

6. Enter your static `IPv4 Address` and `Subnet Mask`, and hit Enter. Note `Default Gateway` will have the same IPv4 address as `Primary DNS Server`. Please note you'll have to confirm the static IPv4 address is available, you can ping it and confirm it's `Unreachable` at this moment.

7. Navigate to `DNS Configuration` and press Enter.

8. Next, select `Use the following DNS server address and hostname` and press the Space key.

9. Insert your `DNS server` IPv4 address, change `Hostname` to `esxi01` and hit Enter.

10. Use the ESC key to go one step back and afterward hit the Y`` key to save changes and restart network management.

11. Go back to `Test Management Network` to ping your default gateway and DNS servers. 

12. Confirm the `Ping Address` and press Enter. Note hostname resolved to 'localhost.localdomain`.

13. To log out, hit the ESC key and press the `F12` key.

14. Finally, run the ESXi virtual machine from the VMware Workstation. After the server is up and running, navigate in your browser to the ESXi server's IPv4 address and you can start managing your VMware ESXi vSphere server.

We're installing and configuring three ESXi hosts, hence you'll have to repeat the `Interactive Installation Step` twice to get total of three ESXi hosts powered on and running.

Also note when you're configuring subsequent esxi, remember to change the `Hostname` in `DNS Configuration` section. For example second and third esxi will be named esxi02 and esxi03 respectively.


-----

## Deploy vCenter Server Appliance

You can deploy the vCenter Server appliance on an ESXi host 7.0 or later, or on a vCenter Server instance 7.0. 

When you use Fully Qualified Domain Names, verify that the client machine from which you are deploying the appliance and the network on which you are deploying the appliance use the same DNS server.

There are two methods of deploying VCSA

- Deploy a vCenter Server Appliance by Using the CLI
- Deploy a vCenter Server Appliance by Using the GUI

We'll implement the CLI method.
 

### Requirements for Deploying the vCenter Server Appliance

Our system must meet specific software and hardware requirements.

**Prerequisistes**

1. Download the vCenter Installer from [Customer Connect account](https://my.vmware.com/web/vmware/)

2. Hardware requirements:
   This depends on the size of your vSphere inventory.
   - We'll use `Tiny Environment`(for up to 10 hosts or 100 virtual machines)
   - 18GB Memory (14GB minimum)
   - Default storage size of 579GB minimum

   Software requirements:

   - Assign a fixed IP address and an FQDN that is resolvable by a DNS server so that clients can reliably access the service.
   - If you use DHCP instead of a static IP address for the vCenter Server appliance, verify that the appliance name is updated in the domain name service (DNS).
   - If you manage network components from outside a firewall, you might be required to reconfigure the firewall to allow access on the appropriate ports. For the list of all supported ports and protocols in vSphere, see the VMware Ports and Protocols [Tool](https://ports.vmware.com)


**vSphere Client Software Requirements**

Use of the vSphere Client requires supported web browsers:
- Google Chrome 89 or later
- Mozilla Firefox 80 or later
- Microsoft Edge 90 or later

Supported Guest Operating Systems
- Windows 32-bit and 64-bit
- Mac OS


**System Requirements for the GUI and CLI Installers**

Windows:

- Windows 8, 8.1, 10
- Windows 2016 server x64 bit
- Windows 2019 server x64 bit
- 4 GB RAM, 2 CPU having 4 cores with 2.3 GHz, 32 GB hard disk, 1 NIC
- Visual C++ redistributable libraries need to be installed to run the CLI installer on versions of Windows older than Windows 10. The Microsoft installers for these libraries are located in the `vcsa-cli-installer/win32/vcredist` directory
- Deploying the vCenter Server appliance with the GUI requires a minimum resolution of
`1024x768` to properly display. Lower resolutions can truncate the UI elements.

Linux:

- SUSE 15
- Ubuntu 16.04 and 18.04(64-bit OS)
- 4 GB RAM, 1 CPU having 2 cores with 2.3 GHz, 16 GB hard disk, 1 NIC

Mac:

- macOS v10.13, 10.14, 10.15
- macOS High Sierra, Mojave, Catalina
- 8 GB RAM, 1 CPU having 4 cores with 2.4 GHz, 150 GB hard disk, 1 NIC
- For client machines that run on Mac 10.13 or later, concurrent GUI deployments of multiple appliances are unsupported. You must deploy the appliances in a sequence.


**Running the vCenter Server Appliance Installer**

1. Navigate to your root directory and extract contents of the `VMware-VCSA` iso file downloaded from VMware Customer Connect account.
   In my case, the root directory is C:\ directory on my Windows local machine.

2. To find the command line tool(Installer), navigate to the `vcsa-cli-installer` subdirectory in the extracted folder of downloaded `VMware-VCSA` iso file.

- If you are running the deployment on Windows OS, executable is located at `vcsa-cli-installer\win32\vcsa-deploy.exe` 
- If you are running the deployment on Linux OS, executable is located at `vcsa-cli-installer/lin64/vcsa-deploy` 
- If you are running the deployment on Mac OS, executable is located at `vcsa-cli-installer/mac/vcsa-deploy`


3. Use the `vcsa-cli-installer\templates\install\embedded_vCSA_on_ESXi.json` template to deploy single instance of VCSA on our second ESXi host.

Edit the template file for your specification. View sample of the manifest we'll use below:

```yaml
{
    "__version": "2.13.0",
    "__comments": "Template to deploy a vCenter Server Appliance with an embedded Platform Services Controller on an ESXi host.",
    "new_vcsa": {
        "esxi": {
            "hostname": "esxi03.localdomain",
            "username": "root",
            "password": "**********",
            "deployment_network": "VM Network",
            "datastore": "datastore3"
        },
        "appliance": {
            "__comments": [
                "You must provide the 'deployment_option' key with a value, which will affect the vCenter Server Appliance's configuration parameters, such as the vCenter Server Appliance's number of vCPUs, the memory size, the storage size, and the maximum numbers of ESXi hosts and VMs which can be managed. For a list of acceptable values, run the supported deployment sizes help, i.e. vcsa-deploy --supported-deployment-sizes"
            ],
            "thin_disk_mode": true,
            "deployment_option": "tiny",
            "name": "Embedded-vCenter-Server-Appliance"
        },
        "network": {
            "ip_family": "ipv4",
            "mode": "static",
            "system_name": "",
            "ip": "192.168.149.7",
            "prefix": "24",
            "gateway": "192.168.149.2",
            "dns_servers": [
                "192.168.149.2"
            ]
        },
        "os": {
            "password": "veinvkrv%$wr428@",
            "ntp_servers": "time.nist.gov",
            "ssh_enable": true
        },
        "sso": {
            "password": "Csgmtehmtrpe61395$%",
            "domain_name": "odennav.local"
        }
    },
    "ceip": {
        "description": {
            "__comments": [
                "++++VMware Customer Experience Improvement Program (CEIP)++++",
                "VMware's Customer Experience Improvement Program (CEIP) ",
                "provides VMware with information that enables VMware to ",
                "improve its products and services, to fix problems, ",
                "and to advise you on how best to deploy and use our ",
                "products. As part of CEIP, VMware collects technical ",
                "information about your organization's use of VMware ",
                "products and services on a regular basis in association ",
                "with your organization's VMware license key(s). This ",
                "information does not personally identify any individual. ",
                "",
                "Additional information regarding the data collected ",
                "through CEIP and the purposes for which it is used by ",
                "VMware is set forth in the Trust & Assurance Center at ",
                "http://www.vmware.com/trustvmware/ceip.html . If you ",
                "prefer not to participate in VMware's CEIP for this ",
                "product, you should disable CEIP by setting ",
                "'ceip_enabled': false. You may join or leave VMware's ",
                "CEIP for this product at any time. Please confirm your ",
                "acknowledgement by passing in the parameter ",
                "--acknowledge-ceip in the command line.",
                "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            ]
        },
        "settings": {
            "ceip_enabled": false
        }
    }
}

```


4. Run a pre-deployment check without deploying the appliance to verify that you prepared the deployment template correctly.

   ```console
   vcsa-deploy install --accept-eula --precheck-only C:\VMware-VCSA-all-7.0.2\vcsa-cli-installer\templates\install\embedded_vCSA_on_ESXi.json
   ```

5. Perform template verification

   ```console
   vcsa-deploy install --accept-eula --verify-template-only C:\VMware-VCSA-all-7.0.2\vcsa-cli-installer\templates\install\embedded_vCSA_on_ESXi.json
   ```

6. Create directory to store output of files that the installer generates
   ```console
   mkdir C:\VCSA-logs
   ```

7. Run the deployment command

   ```console
   vcsa-deploy install --accept-eula  --log-dir=C:\VCSA-logs C:\Users\Admin\Downloads\VMware-VCSA-all-8.0.2-23319993\vcsa-cli-installer\templates\install\embedded_vCSA_on_ESXi.json
   ```
-----

## Configure System Logging.

We'll use the vSphere Client to configure the syslog service globally and edit various advanced settings.

The syslog service receives, categorizes, and stores log messages for analyses that help you take preventive action in your environment.

**Procedure**

1. Browse to the ESXi host in the vSphere Client inventory.
2. Click `Configure`.
3. Under `System`, click `Advanced System Settings`.
4. Click `Edit`.
5. Filter for `syslog`.
6. To set up logging globally and configure various advanced settings, see [ESXi Syslog Options](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-8981F5FA-BB2A-47FB-A59A-7FC5C523CFDE.html#GUID-8981F5FA-BB2A-47FB-A59A-7FC5C523CFDE).
7. (Optional) To overwrite the default log size and log rotation for any of the logs:
   - Click the name of the log that you want to customize.
   - Enter the number of rotations and the log size you want.
8. Click `OK`.

Syslog parameter settings defined by using the vSphere Client or VMware Host Client are effective immediately.

-----

## Manage vCenter Server Services

**Enable Maintenance Mode Operations**

Namespaces are managed by `wcp` service which is needed for maintenance mode operations.

Implement the following steps:

1. Generate SSH key pair and save public key as `~/.ssh/id_rsa.pub`
   
   *This key will also be used for terraform null provisioner*

   ```bash
   ssh-keygen -t rsa -b 4096
   ```

2. Log in as root through an SSH or console session on the vCenter Server Appliance.

3. List the vCenter Server Appliance services
   ```bash
   service-control --list
   ```

4. Check service staus of `wcp`

   ```bash
   service-control --status wcp
   ```

5. Create a backup of /etc/vmware/wcp/wcpsvc.yaml 

   ```bash
   cp /etc/vmware/wcp/wcpsvc.yaml /etc/vmware/wcp/wcpsvc.yaml.bak
   ```

6. Change this line `rhttpproxy_port: {rhttpproxy.ext.port2}` in the above yaml file to `rhttpproxy_port: 443` 


7. Start service staus of `wcp`
   If its stopped, service needs to be started.

   ```bash
   service-control --start wcp
   ```


**Enable Cloning of Virtual Machines**

The  Policy Based Management(PBM) service is required for cloning a virtual machine or deploying a virtual machine from a template.

1. Check service staus of `vmware-sps`

   ```bash
   service-control --status vmware-sps
   ```

2. Start the `vmware-sps` service

   ```bash
   service-control --start vmware-sps
   ```

3. Restart the `vmware-sps` service

   ```bash
   service-control --restart vmware-sps
   ```

-----

##  Enable vSphere vSAN and DRS(Distributed Resource Scheduler)

VMware vSAN is a distributed layer of software that runs natively as a part of the ESXi hypervisor. It uses a software-defined approach that creates shared storage for virtual machines.

It virtualizes the local physical storage resources of ESXi hosts and turns them into pools of storage that can be divided and assigned to virtual machines and applications according to their quality-of-service requirements. vSAN is implemented directly in the ESXi hypervisor.

VMware vSphere Distributed Resource Scheduler (DRS) is the resource scheduling and load balancing solution for vSphere.
DRS works on a cluster of ESXi hosts and provides resource management capabilities like load balancing and virtual machine (VM) placement.

We'll implement the following to enable this solutions in vSphere:

- Install Terraform
- Create Datacenter Cluster and enable vSAN and DRS


**Install Terraform**

Chocolatey is a free and open-source package management system for Windows which we'll use to install Terraform.
Check [Chocolatey](https://chocolatey.org/install) guide for installation method.
 
If you're using a different operating system, check [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) for Terraform install guide.

Verify Chocolatey installation
```bash
choco -help
```

Before we implement Terraform, view the configuration that creates a datacenter cluster and enables vSphere vSAN with DRS:

```yaml

provider "vsphere" {
  user                 = administrator@odennav.local
  password             = **********
  vsphere_server       = vcenter.odennav.local
  allow_unverified_ssl = true
}

variable "datacenter" {
  default = "odennav-dc"
}

variable "hosts" {
  default = [
    "esxi01.localdomain",
    "esxi02.localdomain",
    "esxi03.localdomain",
  ]
}


data "vsphere_host" "host" {
  count         = length(var.hosts)
  name          = var.hosts[count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


resource "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

resource "vsphere_compute_cluster" "compute_cluster" {
  name            = "odennav-dc-cluster"
  datacenter_id   = data.vsphere_datacenter.datacenter.id
  host_system_ids = [data.vsphere_host.host.*.id]

  drs_enabled          = true
  drs_automation_level = "fullyAutomated"

  ha_enabled = false # Initially disable HA

  vsan_enabled = true
  vsan_dedup_enabled = true
  vsan_compression_enabled = true
  vsan_performance_enabled = true
  vsan_verbose_mode_enabled = true
  vsan_network_diagnostic_mode_enabled = true
  vsan_dit_encryption_enabled = true
  vsan_dit_rekey_interval = 1800
  }

```

Install the Terraform package on git bash.
```bash
choco install terraform
```

Verify terraform installation
```bash
terraform version
```

Locate terraform manifests and initialize the directory
Install vSphere providers defined 

```bash
cd terraform-manifest/
terraform init 
```

Format your configuration
```bash
terraform fmt first-deploy.tf
```

Validate your configuration
```bash
terraform validate first-deploy.tf
```

Create an execution plan that describes the planned changes to the vSphere infrastructure
```bash
terraform plan first-deploy.tf
```

Apply the configuration 
```bash
terraform apply first-deploy.tf
```

-----

## Enable vSphere HA(High Availability) and Storage DRS

High Availability is a utility that provides uniform, cost-effective failover protection against hardware and operating system outages within your virtualized IT environment.

vSphere HA allows you to:
 
- Monitor VMware vSphere hosts and virtual machines to detect hardware and guest operating system failures.

- Restart virtual machines on other vSphere hosts in the cluster without manual intervention when a server outage is detected.

- Reduce application downtime by automatically restarting virtual machines upon detection of an operating system failure.

We initialy disabled vSphere HA before enabling vSAN on the cluster. 

Next we can re-enable vSphere HA after vSAN is configured, with manifest below:

```yaml

provider "vsphere" {
  user                 = administrator@odennav.local
  password             = **********
  vsphere_server       = vcenter.odennav.local
  allow_unverified_ssl = true
}


variable "datacenter" {
  default = "odennav-dc"
}


data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}


resource "vsphere_compute_cluster" "compute_cluster" {
  name            = "odennav-dc-cluster"
  datacenter_id   = data.vsphere_datacenter.datacenter.id
  ha_enabled      = true # Enable HA
  }


resource "vsphere_datastore_cluster" "datastore_cluster" {
  name            = "odennav-datastore-cluster"
  datacenter_id   = data.vsphere_datacenter.datacenter.id
  sdrs_enabled    = true
  }

```

Storage DRS allows you to manage the aggregated resources of a datastore cluster.
When Storage DRS is enabled, it provides recommendations for virtual machine disk placement and migration to balance space and I/O resources across the datastores in the datastore cluster.

Implement the following:

Format your configuration
```bash
terraform fmt second-deploy.tf
```

Validate your configuration
```bash
terraform validate second-deploy.tf
```

Create an execution plan that describes the planned changes to the vSphere infrastructure
```bash
terraform plan second-deploy.tf
```

Apply the configuration 
```bash
terraform apply second-deploy.tf
```

-----

## Provision Windows and Linux VMs to vSphere Cluster

**Install Packer**

We'll install Packer with Chocolatey

```bash
choco install packer
```

Verify Packer installation
```bash
packer version
```

Before we implement Packer, note the configuration template that creates a Windows VM image.

```yaml
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
```

Initialize your Packer configuration

```bash
cd ~/vmware-vsphere-/packer/win2016/
packer init template*
```

Ensure template has consistent format

```bash
packer fmt template*
```

Ensure your configuration is syntactically valid and internally consistent

```bash
packer validate template*
```

Build image
```bash
packer build template*
```

View packer_windows2019 and packer_ubuntu20 VM templates created in vSphere web client.


**Provision VMs to vSphere Custer**

Format your configuration
```bash
terraform fmt vm*
```

Validate your configuration
```bash
terraform validate vm*
```

Create an execution plan that describes the planned changes to the vSphere infrastructure
```bash
terraform plan vm*
```

Apply the configuration 
```bash
terraform apply vm*
```

-----

### Next Steps

NSX-T Setup and Configuration


-----

### Media Options for Booting the ESXi Installer(Optional)

[Download and Burn the ESXi installer ISO image to a CD or DVD](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-048CCB07-7E27-4CE8-9E6A-1BF655C33DAC.html)

[To Format a USB flash drive to boot the ESXi installer](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-33C3E7D5-20D0-4F84-B2E3-5CD33D32EAA8.html#GUID-33C3E7D5-20D0-4F84-B2E3-5CD33D32EAA8)

[To Create a USB flash drive and store the ESXi installation script or upgrade script](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-6DC29685-9757-456E-B396-DD6349B75A15.html)

[How to Install VMware ESXi Type-1 Hypervisor](https://mattheweaton.net/posts/how-to-install-vmware-esxi-type-1-hypervisor/)

[Create an Installer ISO Image with a Custom Installation or Upgrade Script](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-C03EADEA-A192-4AB4-9B71-9256A9CB1F9C.html)

[Network Booting the ESXi Installer](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-B9DB94CA-4857-458B-B6F1-6A688726AED0.html)

[Installing and Booting ESXi with Software FCoE](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-C05BAD53-2309-4BC2-9DBF-F2D3313F2B73.html)

[Using Remote Management Applications](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-0E82A6CA-202A-4C5D-8811-53A7CF8D5CDC.html)

[Customizing Installations with vSphere ESXi Image Builder](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-48AC6D6A-B936-4585-8720-A1F344E366F9.html)

[ESXi Requirements](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-E170469F-9C33-4950-8672-9825501557AE.html#GUID-E170469F-9C33-4950-8672-9825501557AE)

[vSphere Auto Deploy ESXi Installation](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-DC5D6EA2-2F17-4CB0-A0DB-C767F2BE2FBA.html)

-----


Enjoy!
