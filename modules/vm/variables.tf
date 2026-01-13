# =============================================================================
# VM Module Variables
# =============================================================================

variable "name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "disk_store" {
  description = "Datastore for the VM"
  type        = string
}

variable "memory" {
  description = "Memory size in MB"
  type        = number
  default     = 2048
}

variable "cpu" {
  description = "Number of vCPUs"
  type        = number
  default     = 2
}

variable "power_state" {
  description = "Power state of VM (on/off)"
  type        = string
  default     = "on"
}

variable "guest_os" {
  description = "Guest OS type (e.g., ubuntu-64, centos-64, windows9-64)"
  type        = string
  default     = "ubuntu-64"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 40
}

variable "boot_disk_type" {
  description = "Boot disk type (thin/thick/eagerzeroedthick)"
  type        = string
  default     = "thin"
}

variable "ovf_source" {
  description = "Path to OVF/OVA file for deployment"
  type        = string
  default     = null
}

variable "clone_from_vm" {
  description = "Name of VM to clone from"
  type        = string
  default     = null
}

variable "network_interfaces" {
  description = "List of network interfaces"
  type = list(object({
    virtual_network = string
    mac_address     = optional(string)
    nic_type        = optional(string, "vmxnet3")
  }))
  default = []
}

variable "guestinfo" {
  description = "Guest info key-value pairs for cloud-init"
  type        = map(string)
  default     = {}
}

variable "notes" {
  description = "VM notes/description"
  type        = string
  default     = "Managed by Terraform"
}
