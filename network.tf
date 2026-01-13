# =============================================================================
# Network Configuration (Optional)
# =============================================================================
# Uncomment and configure to manage networks via Terraform

# module "networks" {
#   source = "./modules/network"
#
#   # Create a new vSwitch (optional)
#   create_vswitch = false
#   vswitch_name   = "vSwitch1"
#   vswitch_ports  = 128
#   vswitch_mtu    = 1500
#
#   # Attach physical NICs to vSwitch (optional)
#   # uplinks = [
#   #   { name = "vmnic1" }
#   # ]
#
#   # Port groups to create
#   port_groups = var.port_groups
# }

# =============================================================================
# Network Outputs (Optional)
# =============================================================================

# output "port_groups" {
#   description = "Created port groups"
#   value       = module.networks.port_groups
# }
