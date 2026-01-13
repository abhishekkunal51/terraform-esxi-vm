# =============================================================================
# VM from OVF/OVA Example
# =============================================================================
# This example deploys a VM from an OVF/OVA template

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

# Deploy VM from OVF/OVA
resource "esxi_guest" "from_ovf" {
  guest_name = var.vm_name
  disk_store = var.datastore
  memsize    = var.memory
  numvcpus   = var.cpu
  power      = "on"
  notes      = "Deployed from OVF - Managed by Terraform"

  # OVF/OVA source - can be local path or URL
  ovf_source = var.ovf_path

  # Override OVF properties if needed
  ovf_properties_timer = 60

  network_interfaces {
    virtual_network = var.network
    nic_type        = "vmxnet3"
  }

  # Cloud-init configuration (for supported images)
  guestinfo {
    key   = "userdata"
    value = base64encode(var.cloud_init_config)
  }

  guestinfo {
    key   = "userdata.encoding"
    value = "base64"
  }
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

variable "vm_name" {
  description = "Name for the VM"
  type        = string
  default     = "vm-from-ovf"
}

variable "datastore" {
  type    = string
  default = "datastore1"
}

variable "network" {
  type    = string
  default = "VM Network"
}

variable "memory" {
  type    = number
  default = 4096
}

variable "cpu" {
  type    = number
  default = 2
}

variable "ovf_path" {
  description = "Path to OVF/OVA file (local path or URL)"
  type        = string
  # Examples:
  # - Local: "/vmfs/volumes/datastore1/templates/ubuntu.ova"
  # - URL: "https://example.com/templates/ubuntu.ova"
}

variable "cloud_init_config" {
  description = "Cloud-init user-data configuration"
  type        = string
  default     = <<-EOF
    #cloud-config
    hostname: vm-from-ovf
    users:
      - name: admin
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ssh-rsa YOUR_SSH_PUBLIC_KEY
    package_update: true
    packages:
      - vim
      - curl
      - wget
  EOF
}

# Outputs
output "vm_id" {
  value = esxi_guest.from_ovf.id
}

output "vm_ip" {
  value = esxi_guest.from_ovf.ip_address
}

output "vm_name" {
  value = esxi_guest.from_ovf.guest_name
}
