# =============================================================================
# Single VM Example
# =============================================================================
# This example creates a single Ubuntu VM on ESXi

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "~> 1.10"
    }
  }
}

# Provider configuration
provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

# Use the VM module
module "ubuntu_vm" {
  source = "../../modules/vm"

  name           = "ubuntu-server-01"
  disk_store     = "datastore1"
  memory         = 4096
  cpu            = 2
  guest_os       = "ubuntu-64"
  boot_disk_size = 40
  boot_disk_type = "thin"
  power_state    = "on"
  notes          = "Ubuntu Server - Created by Terraform"

  network_interfaces = [
    {
      virtual_network = "VM Network"
      nic_type        = "vmxnet3"
    }
  ]
}

# Variables
variable "esxi_hostname" {
  description = "ESXi host IP or hostname"
  type        = string
}

variable "esxi_hostport" {
  description = "ESXi SSH port"
  type        = number
  default     = 22
}

variable "esxi_hostssl" {
  description = "ESXi SSL port"
  type        = string
  default     = "443"
}

variable "esxi_username" {
  description = "ESXi username"
  type        = string
  default     = "root"
}

variable "esxi_password" {
  description = "ESXi password"
  type        = string
  sensitive   = true
}

# Outputs
output "vm_id" {
  value = module.ubuntu_vm.id
}

output "vm_ip" {
  value = module.ubuntu_vm.ip_address
}
