


---

#  AWS Local Lab: The zero-cost ALB & EC2 Simulator

###  Goal
To practice **AWS Solutions Architect Associate (SAA-C03)** concepts without spending money on AWS. We will build a **High Availability** web architecture using your own Linux machine as the data center

---

###  Understanding the translation
Here is how our local tools match AWS services:

| :--- | :--- |
| **Fedora Cloud Image** | **AMI (Amazon Machine Image)** |
| **QEMU/KVM Virtual Machine** | **EC2 Instance** |
| **`virbr0` (Bridge Network)** | **VPC & Subnet** |
| **`user-data` file** | **EC2 User Data (Bootstrapping)** |
| **Nginx (on the Host)** | **Application Load Balancer (ALB)** |
| **`firewalld`** | **Security Groups** |

---

###  Step 1: Install the Tools
First, we need to install the "engines" that run our cloud. 

```bash
# Install Virtualization and Cloud-init tools
sudo dnf install qemu-kvm cloud-utils-growpart libvirt -y

# Install Nginx (Our Load Balancer)
sudo dnf install nginx -y
```

---

###  Step 2: Set up the VPC (Virtual Private Cloud)
In AWS, instances live in a VPC. Locally, we use a **Bridge**.
1. **Start the default network:**
   ```bash
   sudo virsh net-start default
   sudo virsh net-autostart default
   ```
2. **Tell QEMU its allowed to use this bridge:**
   ```bash
   sudo mkdir -p /etc/qemu
   echo "allow virbr0" | sudo tee /etc/qemu/bridge.conf
   sudo chmod u+s /usr/libexec/qemu-bridge-helper
   ```

---

###  Step 3: Download the AMI (Amazon Machine Image) our Base Image
We need the raw operating system. 
1. Download the **Fedora Cloud Base** image (the `.qcow2` file) from the [Fedora website](https://fedoraproject.org/cloud/download).
2. Put it in your project root folder.

---

###  Step 4: Launch the Lab
1. **Prepare the disks:** We don't copy the 2GB image; we create a "Snapshot" (Copy-on-Write) that only saves the changes.
   ```bash
   qemu-img create -f qcow2 -b Fedora-Cloud-Base.qcow2 vms/vm1/fedora-vm.qcow2 20G
   ```
2. **Generate the "User Data":** This tells the VM your password and installs Nginx automatically.
   ```bash
   cloud-localds vms/vm1/seed.iso vms/vm1/user-data vms/vm1/meta-data
   ```
3. **Run the instances:** 
   ```bash
   ./launch-all.sh
   ```

---

###  Step 5: Setting up the Load Balancer (Nginx)
It takes requests from you and sends them to the VMs.

1. **Find your VM IPs:**
   ```bash
   sudo virsh net-dhcp-leases default
   ```
2. **Configure Nginx:** Edit `/etc/nginx/conf.d/local_alb.conf` and tell it to point to those IPs. 
3. **Restart Nginx:** `sudo systemctl restart nginx`

---

###  Step 6: Test  
1. **Round Robin:** Go to `http://localhost`. Refresh. Does the text change from "Target 01" to "Target 02"?
2. **Fault Tolerance:** Kill one VM. Does the website still work? (The ALB should automatically route everything to the survivor).
3. **Bootstrapping:** Delete a `.qcow2` disk, re-create it, and launch. Did the website come back up without you typing any commands inside the VM?

---
