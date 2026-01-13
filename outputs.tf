# =============================================================================
# VM Outputs
# =============================================================================

output "vm_ids" {
  description = "Map of VM names to their IDs"
  value = {
    for key, vm in esxi_guest.vms : key => vm.id
  }
}

output "vm_ip_addresses" {
  description = "Map of VM names to their IP addresses"
  value = {
    for key, vm in esxi_guest.vms : key => vm.ip_address
  }
}

output "vm_details" {
  description = "Detailed information about all VMs"
  value = {
    for key, vm in esxi_guest.vms : key => {
      id         = vm.id
      name       = vm.guest_name
      ip_address = vm.ip_address
      power      = vm.power
      memsize    = vm.memsize
      numvcpus   = vm.numvcpus
      disk_store = vm.disk_store
      guestos    = vm.guestos
    }
  }
}

output "vm_names" {
  description = "List of all VM names"
  value       = [for vm in esxi_guest.vms : vm.guest_name]
}
