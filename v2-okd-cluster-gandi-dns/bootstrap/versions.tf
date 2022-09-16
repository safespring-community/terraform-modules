terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.35"
    }
    gandi = {
      version = "~> 2.1.0"
      source   = "go-gandi/gandi"
    }
  }
  required_version = ">= 0.13"
}
