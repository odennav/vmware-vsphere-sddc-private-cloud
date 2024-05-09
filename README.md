# VMware vSphere SDDC Private Cloud Lab

SDDC (Software Defined Data Center) is an architecture that allows for any application's infrastructure to be fully automated and always available.

It's a special kind of data storage and computing facility in which basic components such as CPU, storage, networking, security are all virtualized and delivered as services via smart software.

**Main Components of VMware SDDC**

- Server Virtualization with VMware's vSphere

- Resource Sharing with VMware vSphere HA and Storage DRS 

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

6. Manage vCenter Server Services

7. vSphere Distributed Switch Setup

8. NFS Storage Server Setup

9. Compute Cluster & Resource Sharing Solutions(vHA, DRS, SDRS)

10. Provision Windows and Linux VMs to vSphere Compute Cluster

11. NSX-T Setup and Configuration


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

To install or upgrade ESXi 7/8, your hardware and system resources must meet the following
requirements:

- Requires a host with at least two CPU cores.

- Supports a broad range of multi-core of 64-bit x86 processors.

- Requires the NX/XD bit to be enabled for the CPU in the BIOS.

- Minimum of 8 GB of physical RAM. Provide at least 8 GB of RAM to run
virtual machines in typical production environments.

- For 64-bit virtual machines, support for hardware virtualization (Intel VT-x or AMD RVI) must be enabled on x64 CPUs.

- Recommended size for VMware ESXi 7/8 is 142GB minimum. VMFS datastore is created automatically to store virtual machine data.
  Local disk of 128 GB or larger for optimal support of ESX-OSData. 
  The disk contains the boot partition, ESX-OSData volume and a VMFS datastore.

- vSphere 7/8 supports booting ESXi hosts from the Unified Extensible Firmware Interface (UEFI). With UEFI, we can boot systems from hard drives, CD-ROM drives, or USB media.
 

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
   
   Use `Bridged` or `NAT` network connection.

7. Select `Power on this virtual machine after creation`.
   
   Click `Finish`.


### Installing ESXi in VMware Workstation

Once your virtual machine is up and running, follow the next steps to finish the ESXi installation on your VMware Workstation.

1. When the `Welcome to the VMware ESXi installation` pops up, press `Enter` to continue.

2. Accept the `End User License Agreement` by hitting the `F11` key.

3. Select the `Local` disk where ESXi will be installed and hit Enter.

4. Choose your `keyboard` layout and hit Enter.

5. Enter your `Root password`, confirm it and securely store it. Press `Enter`.

6. Confirm the installation by pressing `F11`.

7. Once complete, you must remove the installation media. You can remove it by clicking `I Finished Installing` at the bottom right side of the VMware Workstation window.

After removing your installation media, go back to the virtual machine installation screen and hit `Enter` to reboot. The VM will shutdown and reboot.

-----

## Configure ESXi on Hosts

After the reboot is complete and the ESXi virtual machine is running, note the IP address of the ESXi host server.
Dynamic host configuration protocol (DHCP) assigns the IP address the VMware ESXi server uses when it is initialized. 

You can use the IP address assigned from DHCP, or as an alternative, you can set up a static IP address of your choice by following these steps.

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

Also note when you're configuring subsequent ESXi, remember to change the `Hostname` in `DNS Configuration` section. For example second and third ESXi will be named `esxi02` and `esxi03` respectively.

Please note the hardware specifications for esxi02 will be different and bigger than other hosts because we'll deploy the vcsa on it.

-----

## Deploy vCenter Server Appliance

You can deploy the vCenter Server appliance on an ESXi host 7/8, or on a vCenter Server instance 7/8. 

When you use Fully Qualified Domain Names, verify that the client machine from which you are deploying the appliance and the network on which you are deploying the appliance use the same DNS server.

There are two methods of deploying VCSA

- Deploy a vCenter Server Appliance by Using the CLI
- Deploy a vCenter Server Appliance by Using the GUI

We'll implement the CLI method.
 

### Requirements for Deploying the vCenter Server Appliance

Our system must meet specific software and hardware requirements.

**Prerequisistes**

1. Download the vCenter Installer from [Customer Connect account](https://my.vmware.com/web/vmware/)

2. Hardware requirements of ESXi Host:
   
   This depends on the hardware specifications of host esxi02.
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


**Running the vCenter Server Appliance Installer**

1. Navigate to your root directory and extract contents of the `VMware-VCSA` iso file downloaded from VMware Customer Connect account.
   In my case, the root directory is C:\ directory on my Windows local machine.

2. To find the command line tool(Installer), navigate to the `vcsa-cli-installer` subdirectory in the extracted folder of downloaded `VMware-VCSA` iso file.

- If you are running the deployment on Windows OS, executable is located at `vcsa-cli-installer\win32\vcsa-deploy.exe` 
- If you are running the deployment on Linux OS, executable is located at `vcsa-cli-installer/lin64/vcsa-deploy` 
- If you are running the deployment on Mac OS, executable is located at `vcsa-cli-installer/mac/vcsa-deploy`


3. Use the `vcsa-cli-installer\templates\install\embedded_vCSA_on_ESXi.json` template to deploy single instance of VCSA on our second ESXi host.

Edit the template file for your specification. View sample below:

```yaml
{
    "__version": "2.13.0",
    "__comments": "Template to deploy a vCenter Server Appliance with an embedded Platform Services Controller on an ESXi host.",
    "new_vcsa": {
        "esxi": {
            "hostname": "esxi02.localdomain",
            "username": "root",
            "password": "**********",
            "deployment_network": "VM Network",
            "datastore": "datastore2"
        },
        "appliance": {
            "__comments": [
                "You must provide the 'deployment_option' key with a value, which will affect the vCenter Server Appliance's configuration parameters, such as the vCenter Server Appliance's number of vCPUs, the memory size, the storage size, and the maximum numbers of ESXi hosts and VMs which can be managed. For a list of acceptable values, run the supported deployment sizes help, i.e. vcsa-deploy --supported-deployment-sizes"
            ],
            "thin_disk_mode": true,
            "deployment_option": "tiny",
            "name": "vCenter-Server-Appliance"
        },
        "network": {
            "ip_family": "ipv4",
            "mode": "static",
            "system_name": "",
            "ip": "<Static IP address for the appliance.>",
            "prefix": "24",
            "gateway": "<Gateway IP address.>",
            "dns_servers": [
                "<DNS Server IP address.>"
            ]
        },
        "os": {
            "password": "**********",
            "ntp_servers": "time.nist.gov",
            "ssh_enable": true
        },
        "sso": {
            "password": "**********",
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
   cd C:\VMware-VCSA-all-8.0.2\vcsa-cli-installer\win32
   vcsa-deploy install --accept-eula --precheck-only C:\VMware-VCSA-all-8.0.2\vcsa-cli-installer\templates\install\embedded_vCSA_on_ESXi.json
   ```
   Press `1` to accept SHA-1 thumbprint of the certificate.

   View pre-check task completed.


5. Perform template verification

   ```console
   vcsa-deploy install --accept-eula --verify-template-only C:\VMware-VCSA-all-8.0.2\vcsa-cli-installer\templates\install\embedded_vCSA_on_ESXi.json
   ```
   View template-validation task completed.

6. Create directory to store output of files that the installer generates
   ```console
   mkdir C:\VCSA-Logs
   ```

7. Run the deployment command

   ```console
   vcsa-deploy install --accept-eula  --log-dir=C:\VCSA-Logs C:\VMware-VCSA-all-8.0.2\vcsa-cli-installer\templates\install\embedded_vCSA_on_ESXi.json
   ```


### Configure System Logging.

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

Workload Control Plane(wcp) service is needed for maintenance mode operations.

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

6. Open the `wcpsvc.yaml` file and confirm the value of `rhttpproxy_port` is `443` 


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

## vSphere Distributed Switch Setup

This switch is required to handle the networking configuration for all ESXi hosts.

We'll implement the following:
- Create a vSphere Distributed Switch
- Create Distributed Port Groups
- Add Hosts to the vSwitch.
- Create VMkernel Adapters


### Create a vSphere Distributed Switch

**Procedure**

- Navigate to a data center in the vSphere Client

- Right-click the data center and select **`Distributed Switch`** > **`New Distributed Switch`**.

Enter `Odennav-DSwitch` as name for the new distributed switch.

Enter version `8.0` for the distributed switch.

In `Configure Settings`, enter value of `2` as number of uplinks ports.

Review the settings and Click `Finish`.

Right-click the distributed switch just created and select **`Settings`** > **`Edit settings`**.

On the Advanced tab, enter a value of more than `1700` as the MTU value and click `OK`.
The MTU size must be 1700 or greater on any network that carries overlay traffic.


### Create Distributed Port Groups

We'll create port groups for each of the following ESXi services below:
Note their VLAN IDs

- vMotion (VLAN-ID=5)
- Provisioning (VLAN-ID=6)
- Fault Tolerance (VLAN-ID=7)
- vSAN (VLAN-ID=8)
- Management (VLAN-ID=10)
- NSX Tunnel Endpoints (VLAN-ID=20)
- NSX Edge Uplink (VLAN-ID=50)

**Procedure to Create vMotion Port Group**

- Navigate to a data center in the vSphere Client

- Right-click the distributed switch and select **`Distributed Port Group`** > **`New Distributed Port Group`**.

- Create a port group for the vMotion. Name it `DPortGroup-vMotion`.

- Set `VLAN Type` as VLAN Trunking.

- Accept the default VLAN trunk range `(0-4094)`. Set `VLAN ID` to **`5`**.

- Click `Next`, then click `Finish`.

- Right-click the distributed switch, **`Odennav-DSwitch`**, select **`Distributed Port Group`** > **`Manage Distributed Port Groups`**.

- Select `Teaming and failover` and click `Next`.

- Configure active and standby uplinks. Set active uplink as `Uplink1` and standby uplink is `Uplink2`.

- Click `OK` to complete the configuration of the port group.

Repeat steps above to create port groups for other ESXi services listed above.

Also configure the default port group to handle `VM traffic`.



### Add Hosts to the vSwitch

We'll connect the physical NICs, VMkernel adapters and virtual machine network adapters of the hosts to the distributed switch.

**Procedure**

- In the vSphere Client, navigate to **`Networking`** tab and select the distributed switch.

- From the `Actions` menu, select `Add and Manage Hosts`.

- On the `Select task` page, select `Add hosts`, and click `Next`.

- On the `Select hosts` page, click `New hosts`, select the hosts in your data center, click `OK`, and then click `Next`.

On the `Manage physical adapters` page, we'll configure physical NICs on the distributed switch.

- From the `On other switches/unclaimed` list, select a physical NIC.

- Click `Assign uplink`.

- Select an uplink. Assign `Uplink 1` to `vmnic0` and `Uplink 2` to `vmnic1`

- To assign the uplink to all the hosts in the cluster, select **`Apply this uplink assignment to the rest of the hosts`**.

- Click `OK`, then `Next`

On the `Manage VMkernel adapters` page, configure VMkernel adapters.

- Select a VMkernel adapter and click `Assign port group`.

- Select the `DPortGroup-vMotion` distributed port group.

To apply the port group to all hosts in the cluster, select **`Apply this port group assignment to the rest of the hosts`**.

Click `OK`and save this configuration.



### Create VMkernel Adapters

Setup networking TCP/IP stack for the vMotion ESXi service

**Procedure**

- In the vSphere Client, select esxi01 host.

- Under `Manage`, select `Networking` and then select `VMkernel adapters`.

- Click `Add host networking`.

- On the `Select connection type` page, select `VMkernel Network Adapter` and click `Next`.

- On the `Select target device` page, select the created port-group, **`DPortGroup-vMotion`** associatd with **`Odennav-DSwitch`**

- On the `Port` properties, enable **`vMotion`** Traffic and select Next.

- Configure network settings for the vMotion VMkernel interface, use a unique IP address for host's vMotion interface. and click `Next`.
  Note: it is not recommended to override the default gateway.

- Review the settings and click `Finish`.


-----

## NFS Storage Server Setup

### Create NFS virtual machine in VMware Workstation

1. Open your VMware Workstation, click on `Create a New Virtual Machine`

2. Select Installer disc image file (iso): and click Browse... to find the `CentOS 8` Server iso in your directory.
   Click Next.

3. Name the virtual machine as `NFS-Server-1` and select Location you want the NFS server installed.
   Click Next.

4. Select `store virtual disk as a single file` and specify disk capacity of 200GB. Click Next.

5. Click on `Customize Hardware`, then select `Memory` size of 8GB and 4 Processor cores as minimum.

   Select `Virtualize Intel VT-x/EPT or AMD-V/RVI`

6. Use `Bridged` or  `NAT` network connection. For `Bridged` connection, ensure DHCP is properly configured on your router.

7. Select `Power on this virtual machine after creation`.

   Click `Finish`.

### Install CentOS in Virtual Machine

   Once your virtual machine is up and running, follow the next steps to finish the CentOS installation on your VMware Workstation.

1. Set correct `DATE & TIME`

2. Configure preferred `LANGUAGE SUPPORT` and `KEYBOARD` layout.

3. Set `INSTALLATION DESTINATION`

4. Configure `NETWORK & HOSTNAME` and `ROOT PASSWORD`

   Click `Begin Installation` at bottom right corner.


### Install NFS

   Update package list and upgrade all installed packages
   ```bash
   yum update && yum upgrade -y
   ```

   Install NFS utilities and libraries
   ```bash
   yum install nfs-utils libnfsidmap -y
   ```

   Enable and start these services for NFS to function properly
   ```bash
   systemctl enable rpcbind
   systemctl enable nfs-server
   systemctl start rpcbind
   systemctl start rpc-statd
   systemctl start rpc-statd
   systemctl start nfs-idmapd
   ```

   Check available disk partitions
   ```bash
   fdisk -l
   ```

### Add Disks to CentOS Server

We'll create new disk and add to server inventory.
This disk will be used to setup NFS datastore.

- Go to **`Player`** > **`Manage`** > **`Virtual Machine Settings`** at top left of VMware workstartion.
- Click `Add...` at bottom left
- In the popped up `Add Hardware Wizard`, select `Hard Disk` hardware type and click `Next`
- Select `SCSI` as virtual disk type and click `Next`
- Select `Create a new virtual disk` and click `Next`
- Set `Maximum disk size` at 200GB and choose `store virtual disk as a single file`
- Click `Finish`

Notice new `Hard Disk(SCSI)` with size 200GB added to hardware inventory.

Repeat steps above to add another `Hard Disk(SCSI)` with size 5GB.

This disk will be used to setup Heartbeat datastore.

Reboot CentOS server
```bash
reboot
```

### Create XFS Partitions on Linux

Implement the following steps to create XFS partition on disk for NFS:

1. Check available disks detected and confirm new disks
   ```bash
   fdisk -l
   ```
   Note both `/dev/sdb` and `/dev/sdc` now added to list of disks available.

2. Partition second disk available
   ```bash
   fdisk /dev/sdb
   ```

3. System will ask for `Command` input
   Enter `n` to add a new partition

4. Type and enter `p` to select Primary partition type

5. Press `Enter` to set default `partition number` as 1

6. For `First sector` prompt, press `Enter` to use default value of 2048

7. For `Second sector` prompt, press `Enter` again to use default value.

   Note statement of `Partition 1 of type Linux and of size 200GB is set`

8. Type `w` and press `Enter` to write this new partition to the disk and ensure partition table is re-read.

9. Make xfs filesystem on new partition
   ```bash
   mkfs.xfs /dev/sdb1
   ```


Implement the following steps to create XFS partition on disk for Heartbeat:

1. Check available disks detected and confirm new disks
   ```bash
   fdisk -l
   ```
   Note boot partition `/dev/sdb1`

2. Partition second disk available
   ```bash
   fdisk /dev/sdc
   ```

3. System will ask for `Command` input
   Enter `n` to add a new partition

4. Type and enter `p` to select Primary partition type

5. Press `Enter` to set default `partition number` as 1

6. For `First sector` prompt, press `Enter` to use default value of 2048

7. For `Second sector` prompt, press `Enter` again to use default value.

   Note statement of `Partition 1 of type Linux and of size 200GB is set`

8. Type `w` and press `Enter` to write this new partition to the disk and ensure partition table is re-read.

9. Make xfs filesystem on new partition
   ```bash
   mkfs.xfs /dev/sdc1
   ```

### Create NFS Mount Points

  Make new directories as NFS mount points
  ```bash
  mkdir /nfs-share-1
  mkdir /hb-share-1
  ```

  Mount disk partitions
  ```bash
  mount /dev/sdb1 /nfs-share-1
  mount /dev/sdc1 /hb-share-1
  ```

  Check disk space usage and confirm filesystems are mounted
  ```bash
  df -h
  ```

  **Enable Auto Mount**

   Confirm the file sytem table is defined for our new filesystems to be mounted at system boot and normal operations.

   Check `/etc/fstab` and confirm entries for both `/dev/sdb1` and `/dev/sdc1` filesystems.
   
   If not available, add them as shown below:

   Copy config file
   ```bash
   cp /etc/fstab /etc/fstab.bak
   cd /etc
   ```

   Edit fstab configuration file
   ```bash
   vi /etc/fstab
   ```

   ```bash
   /dev/sdb1	/nfs-share-1	xfs	defaults	0	0
   /dev/sdc1	/hb-share-1     xfs	defaults	0	0
   ```

   **Configure Exports Configuration File**
   
   Check `/etc/exports` file used by NFS server to define the directories and options that it will export to NFS clients.

   Copy config file
   ```bash
   cp /etc/exports /etc/exports.bak
   cd /etc
   ```

   Edit exports configuration file
   ```bash
   vi /etc/exports
   ```

   Add entry to exports configuration file
   ```bash
   /nfs-share-1 *(rw,sync,no_root_squash,insecure)
   /hb-share-1 *(rw,sync,no_root_squash,insecure)
   ```

   Export the NFS shares

   ```bash
   exportfs -rv
   ```

   Disabling firewall(optional)

   If firewall is configured to block nfs related ports.
   Please re-open this ports. No need to disable entire firewall.


   **Mount NFS Shares to ESXi Hosts**

   We'll use vCenter server to mount this NFS shares to ESXi hosts in workload cluster named `odennav-dc-cluster.
   This task will be implemented with terraform.


   ```bash
   yum update -y
   yum install net-tools
   ```

   View IP address of NFS server
   ```bash
   ifconfig
   ```

   We'll add the IPv4 address of NFS servers to the terraform manifest `vmware-sddc-private-cloud/terraform-manifest/modules/datastores_nfs/datastores_nfs_main.tf`



   Please note you'll have to create another NFS server to provide redundancy and fault tolerance.
   If one NFS server goes down or experiences issues, clients can still access data from the other NFS server.

   Name of directories to mount as nfs shares:
   - /nfs-share-2
   - /hb-share-2

   For the second NFS server, use same disk sizes for 1st NFS server.

-----

##  Compute Cluster & Resource Sharing Solutions(vHA, DRS, SDRS)


High Availability is a utility that provides uniform, cost-effective failover protection against hardware and operating system outages within your virtualized IT environment.

vSphere HA allows you to:

- Monitor VMware vSphere hosts and virtual machines to detect hardware and guest operating system failures.

- Restart virtual machines on other vSphere hosts in the cluster without manual intervention when a server outage is detected.

- Reduce application downtime by automatically restarting virtual machines upon detection of an operating system failure.


VMware vSphere Distributed Resource Scheduler (DRS) is the resource scheduling and load balancing solution for vSphere.
DRS works on a cluster of ESXi hosts and provides resource management capabilities like load balancing and virtual machine (VM) placement.

Storage DRS allows you to manage the aggregated resources of a datastore cluster.
When Storage DRS is enabled, it provides recommendations for virtual machine disk placement and migration to balance space and I/O resources across the datastores in the datastore cluster.


We'll implement the following to enable this solutions in vSphere using Terraform:

- Install Terraform
- Create Datacenter
- Provision Datacenter cluster and add ESXi hosts
- Create Datastore cluster
- Enable vHA, DRS and SDRS
- Add NFS shares to Datastore Cluster
- Create Inventory tags


**Install Terraform**

Chocolatey is a free and open-source package management system for Windows which we'll use to install Terraform.
Check [Chocolatey](https://chocolatey.org/install) guide for installation method.
 
If you're using a different operating system, check [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) for Terraform install guide.

Verify Chocolatey installation
```bash
choco -help
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
terraform fmt 
```

Validate your configuration
```bash
terraform validate 
```

Create an execution plan that describes the planned changes to the vSphere infrastructure
```bash
terraform plan 
```

Apply the configuration 
```bash
terraform apply --auto-approve
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
cd ~/vmware-vsphere-/packer/
packer init 
```

Ensure template has consistent format

```bash
packer fmt 
```

Ensure your configuration is syntactically valid and internally consistent

```bash
packer validate 
```

Build image
```bash
packer build 
```

View `packer_windows2019` and `packer_ubuntu20` VM templates created in vSphere inventory.


**Provision VMs to vSphere Custer**

Format your configuration
```bash
terraform fmt
```

Validate your configuration
```bash
terraform validate 
```

Create an execution plan that describes the planned changes to the vSphere infrastructure
```bash
terraform plan 
```

Apply the configuration 
```bash
terraform apply 
```

-----

## NSX-T Setup and Configuration

NSX network virtualization programmatically creates and manages virtual networks.

Using network virtualization, the functional equivalent of a network hypervisor we can reproduce the 
complete set of Layer 2 through Layer 7 networking services (for example, switching, routing, 
access control, firewalling, QoS) in software.

NSX works by implementing three separate but integrated planes: management, control and 
data planes

These planes are implemented as a set of processes, modules, and agents residing on two 
types of nodes: 
- NSX Manager 
- Transport Nodes.

**Requirements**

Note the following resources we'll need to configure NSX-T for this project:

- Two datacenter clusters:

  Workload cluster(3 ESXi hosts)
  
  Edge cluster(1 ESXi host)

- vDS(Virtual Distributed Switch) over workload cluster, With six port-groups available for:
  - Management
  - vMotion
  - Provisioning
  - Fault tolerance
  - Tunnel Endpoint
  - NSX Edge(Uplink)


- Enable Jumbo frames by setting MTU to 1700 or larger on VSS(Virtual Standard Switch) and VDS.

- Use physical multilayer switch and configure 3 VLANS:
  
  Mangaement VLAN 
  Tunnel Endpoint(TEP) 
  NSX Edge VLAN 

  These VLANS should be trunked(802.1q) to the ESXi hosts in workload cluster so that they're used with virtual switches.

- NSX-T Data Center needs license for proper configuration and `vSphere7 Enterprise Plus license` needed for ESXi hosts.


### NSX Networking Information

This networking information is required when installing NSX.

The subnet mask is /24 for all the IP addresses below:

VLAN 10 -----------------------> Management traffic 

VLAN 20 -----------------------> For NSX TEP traffic	                                                            

VLAN 50 -----------------------> For traffic between the tier-0 gateway and physical router(NSX edge traffic      

DPortGroup-MGMT -----------> vCenter PG-mgmt backed by VLAN 10 	                                         

Management subnet ----------> 192.168.10.0/24, Default gateway: 192.168.10.1, Subnet mask: 255.255.255.0       

Tunnel Endpoint(TEP) ---------> Subnet 192.168.20.0/24, Default gateway: 192.168.20.1, Subnet-mask:255.255.255.0 
 	
vCenter IP address ------------> 192.168.10.10 (VLAN 10)                                           	

ESXi-1 IP address -------------> 192.168.10.11 (VLAN 10), 192.168.20.11 (VLAN 20)   

ESXi-2 IP address -------------> 192.168.10.12 (VLAN 10), 192.168.20.12 (VLAN 20)
                                                                                    
ESXi-3 IP address -------------> 192.168.10.13 (VLAN 10), 192.168.20.13 (VLAN 20)  

ESXi-4 IP address -------------> 192.168.10.14 (VLAN 10)

NSX-mgr-1 IP address --------> 192.168.10.15 (VLAN 10) 

NSX-mgr-2 IP address --------> 192.168.10.16 (VLAN 10) 

Edge-1 IP address -------------> 192.168.10.17 (VLAN 10), 192.168.20.17 (VLAN 20)	

Edge-2 IP address -------------> 192.168.10.18 (VLAN 10), 192.168.20.18 (VLAN 20)        

Physical router's downlink IP address --------------------------> 192.168.50.1 (VLAN 50)                                                             	                                                                               |                        	

Tier-0 gateway's external-interface IP address on Edge-1 -------> 192.168.50.11 (VLAN 50)                                                           
                                                                                                                                                                       	
Tier-0 gateway's external interface IP address on Edge-2 -------> 192.168.50.12 (VLAN 50)

Tier-0 gateway's virtual IP -----------------------------------------> 192.168.50.13 (VLAN 50)                                                         

LB1.1 subnet -------------------------------------------------------> 192.168.1.0/24


LB-VM-1 IP address -----------------------------------------------> 192.168.1.2                                                                   

WEB1.1 subnet ----------------------------------------------------> 192.168.2.0/24                                                              

WEB-VM-1 IP address --------------------------------------------> 192.168.2.2                                                                   

WEB-VM-2 IP address --------------------------------------------> 192.168.2.3                                                                     	

WEB-VM-3 IP address --------------------------------------------> 192.168.2.4                                                                    


### Deploy NSX-T Manager

NSX-T Manager supports a cluster with three node, which merges policy manager, management, and central control services on a cluster of nodes. 

Clustering is recommended for production environment and this provides high availability of the user interface and API.

Download VMware ovf tool for your preferred operating system from [here](https://developer.vmware.com/web/tool/ovf/) and use it to deploy to an ESXi host.

Due to resources available we'll just install one manager on esxi03 which is managed by vCenter.


**Procedure**

Run the ovftool command with appropriate command parameters.
Installation is done on windows local machine

Ceate directory on local machine for ovftool logs
```console
mkdir C:\ovftool-logs
```

Extract ovftool zipped package to `C:\`  and run below command in Windows command prompt.
Note my extracted folder from zip package is `C:\VMware-ovftool-4.4.3-18663434-win.x86_64`

```console
C:\VMware-ovftool-4.4.3-18663434-win.x86_64\ovftool>ovftool 
--name=nsx-manager-1
--X:injectOvfEnv 
--X:logFile=C:\ovftool-logs\ovftool.log 
--sourceType=OVA 
--vmFolder='' 
--allowExtraConfig 
--datastore=nfs-datastore-1
--net:"" 
--acceptAllEulas 
--skipManifestCheck 
--noSSLVerify 
--diskMode=thin
--quiet 
--hideEula 
--powerOn 
--prop:nsx_ip_0=192.168.10.15  
--prop:nsx_netmask_0=255.255.255.0 
--prop:nsx_gateway_0=192.168.10.1
--prop:nsx_dns1_0=192.168.36.2 
--prop:nsx_domain_0=odennav.local 
--prop:nsx_ntp_0=162.159.200.1 
--prop:nsx_isSSHEnabled=True 
--prop:"nsx_passwd_0=password" 
--prop:"nsx_cli_passwd_0=password-cli" 
--prop:"nsx_cli_audit_passwd_0=password-cli-audit" 
--prop:nsx_hostname=nsx
--prop:mgrhostname01="mgr@gmail.com" 
--prop:nsx_allowSSHRootLogin=True 
--prop:nsx_role="NSX Manager" 
--X:logFile=/root/ovftool/ovf-folder.log 
--X:logLevel=trivia 
--ipProtocol=IPv4 
--ipAllocationPolicy="fixedPolicy" C:\NSX-T Data Center 4.1\nsx-embedded-unified-appliance-4.1.ova \
'vi://Administrator@vsphere.local:<vcenter-password>@192.168.10.10/odennav-datacenter/host/Install/192.168.10.13/
```

The result should look something like this:

```text
Opening OVA source: nsx-embedded-unified-appliance-4.1.ova
The manifest validates
Source is signed and the certificate validates
Opening VI target: vi://Administrator@vsphere.local@192.168.10.13:443/
Deploying to VI: vi://Administrator@vsphere.local@192.168.10.13:443/
Transfer Completed
Powering on VM: NSX Manager
Task Completed
Completed successfully
```

After deployment, verify that the NSX Manager UI comes up by accessing the 
following URL, `192.168.10.15` on your browser.


### NSX IP-Pools Setup 

We'll setup IP pools to assign Tunnel Endpoints to each of our ESXi hosts that are participating in the NSX Overlay networks.

Since we're using three hosts, and expect to deploy 1 edge node, we’ll need a TEP Pool(static IPv4 addresses) with at least 4 IP Addresses.

**Procedure**

Login to NSX Manager


At the NSX-T Manager, go to **`Networking`** -> **`IP Management`** -> **`IP Address Pools`** 

- Click `ADD IP ADDRESS POOL` enter the following details:

  Name --> TEP-Pool
  
  Description --> Tunnel Endpoint Pool


- Click `Set` hyperlink under `Subnets`.

On the `Set Subnets` section, assign the following:

IP Ranges -----> 192.168.20.2-192.168.20.30

CIDR ----------> 192.168.20.0/24

Gateway IP ----> 192.168.20.1

DNS Servers ---> 192.168.36.2

DNS Suffix ----> odennav.local

Click `ADD`

### NSX Transport Zone Setup

Next task is to setup transport zone where data packets are sent between nodes.

The ESXi hosts that participate in NSX networks are grouped in the transport zone.

We'll setup two transport zones:

- Overlay Transport Zones

- VLAN Transport Zones

**Procedure for Overlay Transport Zones**

At the NSX-T Manager, go to **`System`** –> **`Fabric`** –> **`Transport Zones`**

Click the `+` button and assign the the following:

Name ----------> Overlay-Zone

Description ---> NSX Overlay Zone

Switch Name ---> 

Traffic Type --> Overlay

Press `ADD`

**Procedure for VLAN Transport Zones**

At the NSX-T Manager, go to **`System`** –> **`Fabric`** –> **`Transport Zones`**

Click the `+` button and assign the the following:

Name ----------> VLAN-Zone

Description ---> VLAN Transport Zone

Switch Name ---> NSX-VLAN

Traffic Type --> Overlay

Click `ADD` to save this configuration


**Procedure for Uplink Profiles**

This helps to set uplinks for any of the transport nodes we’ll be creating.

We'll use two NICs(Network Interface Cards)

At the NSX-T Manager, go to **`System`** –> **`Fabric`** –> **`Profiles`**

Click on `Uplink Profiles` then press the `+` button and assign the the following:

Name -------------> Overlay-Uplink-Profile

Transport VLAN ---> 20


Save this configuration



**Procedure for Transport Node Profile**

This is used to  provide configuration for each of the ESXi nodes and specify which NICs on the nodes to be configured for the VDS switch.

It also specifies the IP Addresses assigned for the TEP(Tunnel Endpoints) on this switch.

We'll use two NICs(Network Interface Cards)

At the NSX-T Manager, go to **`System`** –> **`Fabric`** –> **`Profiles`**

Click `Transport Node Profiles` then press the `+` button and assign the the following:

Name --------------> Transport-Node-Profile

Description -------> Odennav Transport Node Profile

Type --------------> VDS

Mode --------------> Standard

Name --------------> vcenter.odennav.local     &&    Switch -----> Odennav-DSwitch

Transport Zone ----> Overlay-Zone

Uplink Profile ----> Overlay-Uplink-Profile

IP Assignment -----> Use IP Pool

IP Pool -----------> TEP-Pool

Uplinks -----------> vmnic1(Uplink 1)

Save this configuration.


**Procedure to Configure Transport Nodes**

We apply the transport node profile to configure the transport nodes in the `odennav-dc-cluster`

At the NSX-T Manager, go to **`System`** –> **`Fabric`** –> **`Nodes`**

Click `Host Transport Nodes` then press the `Managed by` button to select the vCenter server.

Select radio button to indicate the chosen workload cluster

Then click on `CONFIGURE NSX` and assign the following:

Transport Node Profile ---> Transport-Node-Profile


Click `APPLY` to configure the ESXi hosts.


Now we've successfully configured our chosen transport nodes and uplinks on vDS with the profiles created.


### Deploy NSX Edge Nodes

NSX-T Edge nodes are used for security and gateway services that can’t be run on the distributed routers in use by NSX-T. 
North/South routing and load balancing services are implemented by edge nodes.

Edge node is deployed to Edge Cluster named `odennav-edge-cluster`.
This approach is best for production setup because these nodes will become a network hotspot.

The Edge VM has a virtual switch inside it, and we’ll connect the edge vm uplinks to the Distributed virtual switch uplinks.

Edge VM will have three or more interfaces:

- Management
- Overlay
- VLAN traffic to the physical network.

**Procedure**

- In NSX Manager, go to **`System`** > **`Fabric`** > **`Nodes`** > **`Edge Transport Nodes`**.

- Click `Add Edge Node`.

Assign the following:

Name -------------------> Edge-1

Host name --------------> edge1.nsx.local

Form Factor ------------> Select the appropriate edge node size.

CLI User Name ----------> admin

CLI Password -----------> ***********	

Allow SSH Login	--------> Select option based on your datacenter policy.

System Root Password----> **************	

Allow Root SSH Login ---> Select option based on your datacenter policy.

Audit User Name	--------> audit 

Audit Password	--------> ********

Compute Manager	--------> vcenter

Cluster	----------------> odennav-dc-cluster

Host -------------------> 192.168.10.11 

Datastore --------------> nfs-datastore-1

IP Assignment ----------> Static

Management IP ----------> 192.168.10.17

Default Gateway --------> 192.168.10.1

Management Interface ---> DPortGroup-MGMT

DNS Servers ------------> 192.168.36.2

NTP Servers ------------> pool.ntp.org

Edge Switch name -------> nsx-overlay, nsx-vlan

Transport Zone ---------> nsx-overlay-transportzone, nsx-vlan-transport-zone

Uplink Profile ---------> Overlay-Uplink-Profile

Teaming Policy(Uplinks)-> DPortGroup-TEP(uplink-1), DPortGroup-EDGE(uplink-1)

IP Assignment ----------> Use Static IP List

Static IP List ---------> 192.168.20.17

Gateway ----------------> 192.168.20.1

Subnet Mask ------------> 255.255.255.0

Wait until the Configuration State column displays `Success`.

You can click the Refresh button to refresh the window.

Repeat steps 4-6 to deploy `Edge-2` on host `192.168.10.12` with management IP `192.168.10.18` and static IP `192.168.20.18`.


### Create an Edge Cluster

**Procedure**

VMware recommend deployment of edge nodes in pairs and pooled together to form an edge cluster.

- In NSX Manager, go to **`System`** > **`Fabric`** > **`Nodes`** > **`Edge Clusters`**.

- Click `Add Edge Cluster`.

Assign the following:

Name ----------------> Edge-cluster-1
  
Description ---------> Odennav Edge Cluster


- Move `Edge-1` and `Edge-2` from the `Available` window to the `Selected` window.

- Save this configuration.

Next, we create overlay networks for our VMs.

-----

### Create Tier-1 Gateways

We'll setup two tier-1 gateways/routers for nsx overlay segments

In NSX Manager, go to **`Networking`** > **`Tier-1 Gateways`**.

Click **`Add Tier-1 Gateway`**.

Assign the following:

Tier-1 Gateway Name --------> T1-gateway-1

Edge Cluster ---------------> Edge-cluster-1

Linked Tier-0 Gateway ------> T0-gateway-1


Under **`Route Advertisement`**, enable the following:
 
`All Connected Segments & Service Ports`
`All Static Routes`
`All IPSec Local Endpoints`

Save the changes.

Repeat steps 2-5 and create T1-gateway-2. Specify the same edge cluster.


### Create NSX Overlay Segments for VMs

We'll create three nsx overlay segments for VMs

In NSX Manager, go to **`Networking`** > **`Segments`**.

Click `Add Segment`.

Assign the following:

Segment Name --------> LB1.1

Connectivity --------> T1-gateway-1

Transport Zone ------> Overlay-Zone

Subnet --------------> 192.168.1.0/24


Repeat steps 2-3 and create WEB1.1 (subnet: 192.168.2.0/24, connectivity: T1-gateway-2) 

Verify that LB1.1 and WEB1.1 are created under the VDS(Odennav-DSwitch) in Vcenter.


### Create NSX Vlan Segment

We'll create a segment for our Tier-0 gateway to use and connect to our physical network.

In NSX Manager, go to **`Networking`** > **`Segments`**.

Click `Add Segment`.

Assign the following:

Segment Name --------> Uplink-Segment

Connectivity --------> T0-gateway-1

Transport Zone ------> VLAN-Zone

Subnet --------------> 192.168.50.2/24

VLAN ----------------> 50

-----

### Create a Tier-0 Gateway

This gateway connects directly to our physical VLAN and provides north/south routing into the NSX overlay networks.

With the Tier-0 Gateway we can connect our new NSX backed overlay segments to the physical network through the NSX-T Edge cluster.

**Procedure**

- In NSX Manager, go to **`Networking`** > **`Tier-0 Gateways`**.

- Click `Add Tier-0 Gateway`.

- Enter a name for the gateway, for example, `T0-gateway-1`.

- Select the HA (high availability) mode `Active Standby`.

- Select the Edge cluster `Edge-Cluster-1`.

- Click `Save` and continue configuring this gateway.

- Click `Interfaces` and click `Set`.

- Click `Add Interface`.

- Enter a name, for example, IP1-EdgeNode1.

- Enter the IP address 192.168.50.11/24.

- In the `Connected To (Segment)` field, select Uplink-segment-1.

- In the Edge Node field, select `Edge-1`.

- Save the changes.

- Repeat steps 8-13 to configure a second interface called IP2-EdgeNode2. The IP address 
  should be 192.168.50.12/24. The `Edge Node` should be `Edge-2`.

- In the `HA VIP Configuration` field, click `Set` to create a virtual IP for the tier-0 
  gateway.

- Enter the IP address 192.168.50.13/24.

- Select the interfaces IP1-EdgeNode1 and IP2-EdgeNode2.

- Save the changes.


### Configure Routing on the Physical Router and Tier-0 Gateway

**Procedure**

- On the physical router, configure a static route to the subnets 192.168.1.0/24 and 192.168.2.0/24 via 192.168.50.13,
  which is the virtual IP address of the tier-0 gateway's external interface.

- In NSX Manager, go to Networking > Tier-0 Gateways.

- Edit T0-gateway-1.

- Under Routing > Static Routes, click Set and click Add Static Route.

- In the Name field, enter default.

- In the Network field, enter 0.0.0.0/0.

- Click Set Next Hops.

- In the IP Address field, enter 192.168.50.1.

- Click Add.

- Save the changes.


Finally, we've deployed Tier-0 router and connected NSX-T backed overlay segments to your physical network. 

Implement the following to test east-west and north-south connectivity:

- Ping WEB-VM-1 from LB-VM-1 and vice versa
- Ping the downlink interface of the physical router from WEB-VM-1.


Please note for VMs deployed to NSX-T overlay segments, ensure the network adapter is set to correct overlay segment.


-----




### Next Steps

vSphere with Kubernetes

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

