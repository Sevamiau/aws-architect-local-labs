# AWS - Local Infrastructure Lab

This project simulates a **High Availability (HA) Web Architecture** locally on Fedora Linux. It emulates the core components of an AWS VPC, EC2 Instances, and an Application Load Balancer (ALB).

##  Architecture
- **ALB (Load Balancer):** Nginx running on the Fedora Host (Layer 7).
- **VPC / Subnet:** `virbr0` Linux Bridge providing Private IP addresses.
- **EC2 Instances (Targets):** Two QEMU/KVM Virtual Machines running Fedora Cloud images.
- **Provisioning:** Cloud-init via Seed ISOs for automated user and hostname setup.

##  Key Learning Objectives (SAA-C03)
- **High Availability:** Traffic is distributed across multiple "Availability Zones" (VMs).
- **Health Checks:** The ALB automatically detects if a Target is down and routes traffic to the healthy one.
- **SSL Termination:** Simulated local certificate handling via Nginx.
- **Bootstrapping:** Automated software installation via `user-data`.

##  Usage
1. **Launch the Infrastructure:** Run ```./launch-all.sh``` to start the VMs if you have kitty as your terminal or `./run-target.sh` with its args if you don't (e.g: ```./run-target.sh Target-01 vms/vm1/fedora-vm/qcow2 vms/vm1/seed.iso``` ). 
2. **Access the ALB:** Visit `http://localhost`. You will see traffic alternating between Target-01 and Target-02.
3. **Test Fault Tolerance:** Stop a VM and observe the ALB routing 100% of traffic to the survivor.
