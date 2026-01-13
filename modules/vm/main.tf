# =============================================================================
# ESXi VM Module
# =============================================================================
# Reusable module for creating a single VM on ESXi

terraform {
  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "~> 1.10"
    }
  }
}

resource "esxi_guest" "vm" {
  guest_name = var.name
  disk_store = var.disk_store
  memsize    = var.memory
  numvcpus   = var.cpu
  power      = var.power_state
  notes      = var.notes
  guestos    = var.guest_os

  # Boot disk
  boot_disk_size = var.boot_disk_size
  boot_disk_type = var.boot_disk_type

  # Source for VM creation
  ovf_source    = var.ovf_source
  clone_from_vm = var.clone_from_vm

  # Network interfaces
  dynamic "network_interfaces" {
    for_each = var.network_interfaces
    content {
      virtual_network = network_interfaces.value.virtual_network
      mac_address     = lookup(network_interfaces.value, "mac_address", null)
      nic_type        = lookup(network_interfaces.value, "nic_type", "vmxnet3")
    }
  }

  # Guest customization
  dynamic "guestinfo" {
    for_each = var.guestinfo
    content {
      key   = guestinfo.key
      value = guestinfo.value
    }
  }
}
