VM_ID=$((RANDOM % 100))

qemu-system-x86_64 \
  -m 1G \
  -smp 2 \
  -enable-kvm \
  -cpu host \
  -drive if=virtio,file=fedora-vm.qcow2 \
  -drive if=virtio,format=raw,file=seed.iso \
  -netdev bridge,id=net0,br=virbr0 \
  -device virtio-net-pci,netdev=net0,mac=52:54:00:12:34:$VM_ID \
  -nographic
