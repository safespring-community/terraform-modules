terraform {
  required_providers {
    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "~> 2.1"
    }
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "~> 1.35"
    }
    gandi = {
      version = "2.0.0-rc3" 
      source   = "psychopenguin/gandi"
    }
  }
  required_version = ">= 0.13"
}
