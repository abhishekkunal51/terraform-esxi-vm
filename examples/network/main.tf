# =============================================================================
# Network Module Example
# =============================================================================
# This example creates a virtual switch and multiple port groups

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

# -----------------------------------------------------------------------------
# Example 1: Create port groups on existing vSwitch
# -----------------------------------------------------------------------------

module "app_networks" {
  source = "../../modules/network"

  create_vswitch = false

  port_groups = {
    "web-network" = {
      name    = "Web-Network"
      vswitch = "vSwitch0"
      vlan    = 100
    }
    "app-network" = {
      name    = "App-Network"
      vswitch = "vSwitch0"
      vlan    = 200
    }
    "db-network" = {
      name    = "DB-Network"
      vswitch = "vSwitch0"
      vlan    = 300
    }
  }
}

# -----------------------------------------------------------------------------
# Example 2: Create new vSwitch with port groups
# -----------------------------------------------------------------------------

module "isolated_network" {
  source = "../../modules/network"

  create_vswitch = true
  vswitch_name   = "vSwitch-Isolated"
  vswitch_ports  = 128
  vswitch_mtu    = 1500

  # Attach physical NIC (optional)
  # uplinks = [
  #   { name = "vmnic1" }
  # ]

  port_groups = {
    "isolated-mgmt" = {
      name             = "Isolated-Management"
      vlan             = 10
      promiscuous_mode = false
    }
    "isolated-data" = {
      name             = "Isolated-Data"
      vlan             = 20
      promiscuous_mode = false
    }
  }
}

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

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

# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------

output "app_port_groups" {
  value = module.app_networks.port_groups
}

output "isolated_vswitch" {
  value = module.isolated_network.vswitch_name
}

output "isolated_port_groups" {
  value = module.isolated_network.port_groups
}
