# =============================================================================
# ESXi Virtual Machines
# =============================================================================
# This configuration creates virtual machines on a standalone ESXi host
# using the josenk/esxi community provider.

resource "esxi_guest" "vms" {
  for_each = var.vms

  guest_name = each.value.guest_name
  disk_store = each.value.disk_store
  memsize    = each.value.memsize
  numvcpus   = each.value.numvcpus
  power      = each.value.power
  notes      = each.value.notes

  # Guest OS type (e.g., ubuntu-64, centos-64, windows9-64)
  guestos = each.value.guest_type

  # Boot disk configuration
  boot_disk_size = each.value.boot_disk_size
  boot_disk_type = each.value.boot_disk_type

  # OVF/OVA source for deployment (optional)
  ovf_source = each.value.ovf_source

  # Clone from existing VM (optional)
  clone_from_vm = each.value.clone_from_vm

  # Network interfaces
  dynamic "network_interfaces" {
    for_each = each.value.network_interfaces
    content {
      virtual_network = network_interfaces.value.virtual_network
      mac_address     = network_interfaces.value.mac_address
      nic_type        = network_interfaces.value.nic_type
    }
  }

  # Additional virtual disks
  dynamic "virtual_disks" {
    for_each = each.value.additional_disks
    content {
      virtual_disk_id = esxi_virtual_disk.additional_disks["${each.key}-${virtual_disks.key}"].id
      slot            = "0:${virtual_disks.key + 1}"
    }
  }
}

# =============================================================================
# Additional Virtual Disks
# =============================================================================

locals {
  # Flatten additional disks for all VMs
  additional_disks = merge([
    for vm_key, vm in var.vms : {
      for idx, disk in vm.additional_disks :
      "${vm_key}-${idx}" => {
        vm_key     = vm_key
        disk_store = disk.disk_store
        size       = disk.size
        disk_type  = disk.disk_type
      }
    }
  ]...)
}

resource "esxi_virtual_disk" "additional_disks" {
  for_each = local.additional_disks

  virtual_disk_disk_store = each.value.disk_store
  virtual_disk_dir        = var.vms[each.value.vm_key].guest_name
  virtual_disk_size       = each.value.size
  virtual_disk_type       = each.value.disk_type
}
