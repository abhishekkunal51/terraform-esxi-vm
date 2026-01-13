# =============================================================================
# VM Module Outputs
# =============================================================================

output "id" {
  description = "VM ID"
  value       = esxi_guest.vm.id
}

output "name" {
  description = "VM name"
  value       = esxi_guest.vm.guest_name
}

output "ip_address" {
  description = "VM IP address"
  value       = esxi_guest.vm.ip_address
}

output "power_state" {
  description = "VM power state"
  value       = esxi_guest.vm.power
}

output "guest_os" {
  description = "Guest OS type"
  value       = esxi_guest.vm.guestos
}
