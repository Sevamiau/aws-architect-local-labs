#!/bin/bash

VM_NAME=$1
DISK=$2
SEED=$3

if [ ! -f "$DISK" ] || [ ! -f "$SEED" ]; then
  echo "Error: Files not found!"
  echo "Check: $DISK and $SEED"
  exit 1
fi

MAC="52:54:00:$(printf '%02x:%02x:%02x' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256)))"

echo "Starting $VM_NAME with MAC $MAC..."

qemu-system-x86_64 \
  -m 1G -smp 2 -enable-kvm -cpu host \
  -drive if=virtio,file="$DISK" \
  -drive if=virtio,format=raw,file="$SEED" \
  -netdev bridge,id=net0,br=virbr0 \
  -device virtio-net-pci,netdev=net0,mac="$MAC" \
  -nographic
