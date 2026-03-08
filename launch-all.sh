#!/bin/bash

COMMAND1="./run-target.sh Target-01 vms/vm1/fedora-vm.qcow2 vms/vm1/seed.iso"
COMMAND2="./run-target.sh Target-02 vms/vm2/fedora-vm.qcow2 vms/vm2/seed.iso"

kitty --title "Target-01" sh -c "$COMMAND1" &
sleep 2
kitty --title "Target-02" sh -c "$COMMAND2" &
