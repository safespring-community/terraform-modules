terraform {
  required_providers {
    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "= 2.4"
    }
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.35"
    }
  }
  required_version = ">= 0.13"
}
