# =============================================================================
# ESXi Connection Variables
# =============================================================================

variable "esxi_hostname" {
  description = "ESXi host IP address or hostname"
  type        = string
}

variable "esxi_hostport" {
  description = "ESXi host SSH port (default: 22)"
  type        = number
  default     = 22
}

variable "esxi_hostssl" {
  description = "ESXi host SSL port for API (default: 443)"
  type        = string
  default     = "443"
}

variable "esxi_username" {
  description = "ESXi host username"
  type        = string
  default     = "root"
}

variable "esxi_password" {
  description = "ESXi host password"
  type        = string
  sensitive   = true
}

# =============================================================================
# VM Configuration Variables
# =============================================================================

variable "vms" {
  description = "Map of virtual machines to create"
  type = map(object({
    guest_name     = string
    disk_store     = string
    memsize        = optional(number, 2048)
    numvcpus       = optional(number, 2)
    power          = optional(string, "on")
    guest_type     = optional(string, "ubuntu-64")
    boot_disk_size = optional(number, 40)
    boot_disk_type = optional(string, "thin")
    ovf_source     = optional(string, null)
    clone_from_vm  = optional(string, null)
    network_interfaces = optional(list(object({
      virtual_network = string
      mac_address     = optional(string, null)
      nic_type        = optional(string, "vmxnet3")
    })), [])
    additional_disks = optional(list(object({
      disk_store    = string
      size          = number
      disk_type     = optional(string, "thin")
    })), [])
    guestinfo = optional(map(string), {})
    notes     = optional(string, "Managed by Terraform")
  }))
  default = {}
}

# =============================================================================
# Default Values
# =============================================================================

variable "default_datastore" {
  description = "Default datastore for VMs if not specified"
  type        = string
  default     = "datastore1"
}

variable "default_network" {
  description = "Default network for VMs if not specified"
  type        = string
  default     = "VM Network"
}

variable "default_guest_type" {
  description = "Default guest OS type"
  type        = string
  default     = "ubuntu-64"
}

# =============================================================================
# Network Configuration Variables
# =============================================================================

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
