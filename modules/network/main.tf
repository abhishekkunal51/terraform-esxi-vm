# =============================================================================
# ESXi Network Module
# =============================================================================
# Manages virtual switches and port groups on ESXi

terraform {
  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "~> 1.10"
    }
  }
}

# =============================================================================
# Virtual Switches
# =============================================================================

resource "esxi_vswitch" "vswitch" {
  count = var.create_vswitch ? 1 : 0

  name           = var.vswitch_name
  ports          = var.vswitch_ports
  mtu            = var.vswitch_mtu
  link_discovery_mode = var.link_discovery_mode

  # Uplink configuration
  dynamic "uplink" {
    for_each = var.uplinks
    content {
      name = uplink.value.name
    }
  }
}

# =============================================================================
# Port Groups
# =============================================================================

resource "esxi_portgroup" "portgroup" {
  for_each = var.port_groups

  name    = each.value.name
  vswitch = var.create_vswitch ? esxi_vswitch.vswitch[0].name : each.value.vswitch
  vlan    = each.value.vlan

  # Promiscuous mode (optional)
  promiscuous_mode = lookup(each.value, "promiscuous_mode", false)

  # MAC address changes (optional)
  mac_changes = lookup(each.value, "mac_changes", false)

  # Forged transmits (optional)
  forged_transmits = lookup(each.value, "forged_transmits", false)
}
