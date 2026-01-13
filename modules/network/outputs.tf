# =============================================================================
# Network Module Outputs
# =============================================================================

output "vswitch_id" {
  description = "ID of the created virtual switch"
  value       = var.create_vswitch ? esxi_vswitch.vswitch[0].id : null
}

output "vswitch_name" {
  description = "Name of the virtual switch"
  value       = var.create_vswitch ? esxi_vswitch.vswitch[0].name : var.vswitch_name
}

output "port_group_ids" {
  description = "Map of port group names to their IDs"
  value = {
    for key, pg in esxi_portgroup.portgroup : key => pg.id
  }
}

output "port_group_names" {
  description = "List of created port group names"
  value = [for pg in esxi_portgroup.portgroup : pg.name]
}

output "port_groups" {
  description = "Details of all port groups"
  value = {
    for key, pg in esxi_portgroup.portgroup : key => {
      id      = pg.id
      name    = pg.name
      vswitch = pg.vswitch
      vlan    = pg.vlan
    }
  }
}
