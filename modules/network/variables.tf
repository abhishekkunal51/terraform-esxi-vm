# =============================================================================
# Network Module Variables
# =============================================================================

# -----------------------------------------------------------------------------
# Virtual Switch Configuration
# -----------------------------------------------------------------------------

variable "create_vswitch" {
  description = "Whether to create a new virtual switch"
  type        = bool
  default     = false
}

variable "vswitch_name" {
  description = "Name of the virtual switch"
  type        = string
  default     = "vSwitch1"
}

variable "vswitch_ports" {
  description = "Number of ports on the virtual switch"
  type        = number
  default     = 128
}

variable "vswitch_mtu" {
  description = "MTU size for the virtual switch"
  type        = number
  default     = 1500
}

variable "link_discovery_mode" {
  description = "Link discovery mode (disabled, listen, advertise, both)"
  type        = string
  default     = "listen"
}

variable "uplinks" {
  description = "List of physical NICs to attach to the vSwitch"
  type = list(object({
    name = string
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Port Group Configuration
# -----------------------------------------------------------------------------

variable "port_groups" {
  description = "Map of port groups to create"
  type = map(object({
    name             = string
    vswitch          = optional(string, "vSwitch0")
    vlan             = optional(number, 0)
    promiscuous_mode = optional(bool, false)
    mac_changes      = optional(bool, false)
    forged_transmits = optional(bool, false)
  }))
  default = {}
}
