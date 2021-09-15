#!/bin/bash

qm create {{ vm.id }} -name "{{ vm.name }}" -memory 1024 -net0 virtio,bridge=vmbr1 -cores 1 -sockets 1

# Import the downloaded image to proxmox...
qm importdisk {{ vm.id }} {{ vm.img }} local-lvm

# ...and then attach it to the VM
qm set {{ vm.id }} -scsihw virtio-scsi-pci -virtio0 local-lvm:vm-{{ vm.id }}-disk-0

# You'll want to set up a serial console. Configuration may look different based on which distribution you use.
qm set {{ vm.id }} --serial0 socket --vga serial0

# Manually setting the boot drive will improve boot times.
qm set {{ vm.id }} -boot c -bootdisk virtio0

# Add Cloud Init data as a second disk.
qm set {{ vm.id }} -ide2 local-lvm:cloudinit

# This enables the Qemu agent. Adjust if you don't need it
qm set {{ vm.id }} -agent 1

# By default, Proxmox generates the vCPU count
# using sockets * cores
# so this may be unnecessary
qm set {{ vm.id }} -vcpus 1

# Allow hotplugging of network, USB and disks
qm set {{ vm.id }} -hotplug disk,network,usb

# Resize the primary boot disk (otherwise it will be around 2G by default)
# If you go bigger than intended, you CANNOT shrink the disk
qm resize {{ vm.id }} virtio0 10G

# Once everything looks good, convert the VM to a template
qm template {{ vm.id }}

# Displays the VM configuration
qm config {{ vm.id }}