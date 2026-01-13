# =============================================================================
# Multiple VMs Example
# =============================================================================
# This example creates multiple VMs using for_each

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "~> 1.10"
    }
  }
}

provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_hostssl  = var.esxi_hostssl
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

# Define multiple VMs
locals {
  vms = {
    "web-01" = {
      memory   = 2048
      cpu      = 2
      guest_os = "ubuntu-64"
      notes    = "Web Server 1"
    }
    "web-02" = {
      memory   = 2048
      cpu      = 2
      guest_os = "ubuntu-64"
      notes    = "Web Server 2"
    }
    "app-01" = {
      memory   = 4096
      cpu      = 4
      guest_os = "centos-64"
      notes    = "Application Server"
    }
    "db-01" = {
      memory   = 8192
      cpu      = 4
      guest_os = "centos-64"
      notes    = "Database Server"
    }
  }
}

# Create VMs using the module
module "vms" {
  source   = "../../modules/vm"
  for_each = local.vms

  name           = each.key
  disk_store     = var.datastore
  memory         = each.value.memory
  cpu            = each.value.cpu
  guest_os       = each.value.guest_os
  boot_disk_size = 40
  boot_disk_type = "thin"
  power_state    = "on"
  notes          = each.value.notes

  network_interfaces = [
    {
      virtual_network = var.network
      nic_type        = "vmxnet3"
    }
  ]
}

# Variables
variable "esxi_hostname" {
  type = string
}

variable "esxi_hostport" {
  type    = number
  default = 22
}

variable "esxi_hostssl" {
  type    = string
  default = "443"
}

variable "esxi_username" {
  type    = string
  default = "root"
}

variable "esxi_password" {
  type      = string
  sensitive = true
}

variable "datastore" {
  type    = string
  default = "datastore1"
}

variable "network" {
  type    = string
  default = "VM Network"
}

# Outputs
output "vm_ips" {
  value = {
    for name, vm in module.vms : name => vm.ip_address
  }
}

output "vm_ids" {
  value = {
    for name, vm in module.vms : name => vm.id
  }
}
