# Terraform ESXi VM Management

Terraform project for managing Virtual Machines on standalone VMware ESXi hosts.

## Overview

This project uses the [josenk/esxi](https://registry.terraform.io/providers/josenk/esxi/latest) community provider to manage VMs directly on ESXi hosts without requiring vCenter Server.

## Features

- Create and manage VMs on standalone ESXi hosts
- Support for multiple VMs using `for_each`
- Deploy VMs from OVF/OVA templates
- Clone existing VMs
- Configure network interfaces
- Add additional virtual disks
- Cloud-init support for guest customization
- Reusable VM module

## Prerequisites

- Terraform >= 1.0.0
- ESXi host with SSH enabled
- ESXi host credentials (root or privileged user)
- Network connectivity to ESXi host

### ESXi Host Requirements

1. **Enable SSH on ESXi host:**
   - Via vSphere Client: Host > Manage > Services > SSH > Start
   - Or via DCUI: Troubleshooting Options > Enable SSH

2. **Firewall rules (if needed):**
   ```bash
   esxcli network firewall ruleset set -e true -r sshClient
   ```

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/terraform-esxi-vm.git
   cd terraform-esxi-vm
   ```

2. **Create terraform.tfvars:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit terraform.tfvars with your ESXi details:**
   ```hcl
   esxi_hostname = "192.168.1.100"
   esxi_username = "root"
   esxi_password = "your-password"

   vms = {
     "my-vm" = {
       guest_name     = "my-vm"
       disk_store     = "datastore1"
       memsize        = 4096
       numvcpus       = 2
       guest_type     = "ubuntu-64"
       boot_disk_size = 40
       network_interfaces = [
         { virtual_network = "VM Network" }
       ]
     }
   }
   ```

4. **Initialize and apply:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Project Structure

```
terraform-esxi-vm/
├── main.tf                    # Main VM resources
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── providers.tf               # Provider configuration
├── versions.tf                # Version constraints
├── terraform.tfvars.example   # Example variables file
├── modules/
│   └── vm/                    # Reusable VM module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── examples/
    ├── single-vm/             # Single VM example
    ├── multiple-vms/          # Multiple VMs example
    └── vm-from-ovf/           # OVF deployment example
```

## Usage Examples

### Single VM

```hcl
module "web_server" {
  source = "./modules/vm"

  name           = "web-server-01"
  disk_store     = "datastore1"
  memory         = 4096
  cpu            = 2
  guest_os       = "ubuntu-64"
  boot_disk_size = 40

  network_interfaces = [
    {
      virtual_network = "VM Network"
      nic_type        = "vmxnet3"
    }
  ]
}
```

### Multiple VMs

```hcl
vms = {
  "web-01" = {
    guest_name = "web-01"
    disk_store = "datastore1"
    memsize    = 2048
    numvcpus   = 2
    guest_type = "ubuntu-64"
    network_interfaces = [
      { virtual_network = "VM Network" }
    ]
  }
  "db-01" = {
    guest_name = "db-01"
    disk_store = "datastore1"
    memsize    = 8192
    numvcpus   = 4
    guest_type = "centos-64"
    network_interfaces = [
      { virtual_network = "VM Network" }
    ]
    additional_disks = [
      { disk_store = "datastore1", size = 200 }
    ]
  }
}
```

### VM from OVF/OVA

```hcl
resource "esxi_guest" "from_template" {
  guest_name = "ubuntu-from-ova"
  disk_store = "datastore1"
  ovf_source = "/vmfs/volumes/datastore1/templates/ubuntu.ova"

  network_interfaces {
    virtual_network = "VM Network"
  }
}
```

## Variables Reference

### ESXi Connection

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `esxi_hostname` | ESXi host IP/hostname | string | - |
| `esxi_hostport` | ESXi SSH port | number | 22 |
| `esxi_hostssl` | ESXi SSL port | string | "443" |
| `esxi_username` | ESXi username | string | "root" |
| `esxi_password` | ESXi password | string | - |

### VM Configuration

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `guest_name` | VM name | string | - |
| `disk_store` | Datastore name | string | - |
| `memsize` | Memory in MB | number | 2048 |
| `numvcpus` | Number of vCPUs | number | 2 |
| `guest_type` | Guest OS type | string | "ubuntu-64" |
| `boot_disk_size` | Boot disk size (GB) | number | 40 |
| `boot_disk_type` | Disk type (thin/thick) | string | "thin" |
| `power` | Power state (on/off) | string | "on" |

### Supported Guest OS Types

| OS | Guest Type Value |
|----|------------------|
| Ubuntu 64-bit | `ubuntu-64` |
| CentOS 64-bit | `centos-64` |
| RHEL 64-bit | `rhel-64` |
| Debian 64-bit | `debian-64` |
| Windows Server 2019 | `windows9Server64Guest` |
| Windows Server 2022 | `windows2019srv-64` |
| Other Linux | `other3xLinux-64` |

## Outputs

| Output | Description |
|--------|-------------|
| `vm_ids` | Map of VM names to IDs |
| `vm_ip_addresses` | Map of VM names to IP addresses |
| `vm_details` | Detailed VM information |

## Troubleshooting

### SSH Connection Issues

1. Verify SSH is enabled on ESXi host
2. Check firewall rules
3. Test SSH connection manually:
   ```bash
   ssh root@<esxi-host>
   ```

### Provider Installation

If the provider fails to download:
```bash
terraform init -upgrade
```

### VM Creation Fails

1. Check datastore name is correct
2. Verify network name exists
3. Ensure sufficient resources on host

## Security Notes

- Never commit `terraform.tfvars` with passwords
- Use environment variables for sensitive data:
  ```bash
  export TF_VAR_esxi_password="your-password"
  ```
- Consider using HashiCorp Vault for secrets management

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License

## References

- [ESXi Provider Documentation](https://registry.terraform.io/providers/josenk/esxi/latest/docs)
- [Terraform Documentation](https://www.terraform.io/docs)
- [VMware ESXi Documentation](https://docs.vmware.com/en/VMware-vSphere/index.html)
