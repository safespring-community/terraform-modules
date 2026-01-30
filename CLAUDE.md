# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Terraform modules for the Safespring OpenStack platform. The "v2" prefix in module names refers to the Safespring v2 platform.

## Module Reference Pattern

Modules are consumed via GitHub URLs:
```hcl
source = "github.com/safespring-community/terraform-modules/v2-compute-instance"
```

## Key Modules

### v2-compute-instance
General-purpose compute instance module with smart disk handling:
- Flavors starting with `l` (e.g., `l2.c2r4.100`) use local disk
- Other flavors automatically use boot-from-volume
- Supports data disks via `data_disks` map
- Instance metadata includes `role` and `wg_ip` for Ansible inventory integration
- Uses `lifecycle { ignore_changes = all }` to prevent recreation

### v2-compute-security-group
Flexible security group with dynamic rules from a map. Supports `remote_group_id = "self"` for self-referencing rules.

### v2-compute-interconnect-security-group
Pre-configured security group allowing full TCP/UDP/ICMP traffic between members (self-referencing rules).

### v2-okd-cluster-gandi-dns
OKD/OpenShift cluster deployment with submodules:
- `topology/` - Network and security groups (consumed by other submodules)
- `loadbalancer/` - External load balancer with Gandi DNS
- `bootstrap/` - Bootstrap nodes for cluster init
- `masters/` - Control plane nodes with anti-affinity support
- `workers/` - Worker nodes with multiple worksets via `for_each`

## Terraform Commands

```bash
# Initialize module
terraform init

# Validate configuration
terraform validate

# Plan changes
terraform plan

# Apply changes
terraform apply
```

## Provider Requirements

- Terraform >= 0.13 (some modules require >= 0.14)
- OpenStack provider ~> 1.35
- Ignition provider (for OKD cluster module)

## Architecture Notes

- Security groups flow from topology module to instance modules via `*_sg_names` outputs
- The OKD cluster module uses Ignition for node configuration
- Worker sets allow heterogeneous worker pools with different flavors and disk sizes
- Examples in `examples/` often combine Terraform with Ansible for post-deployment configuration
