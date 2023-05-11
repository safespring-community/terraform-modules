terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      configuration_aliases = [ openstack.sto1-sandbox, openstack.psnc-dcw]
    }
  gandi = {
    version = "~> 2.1.0"
    source   = "go-gandi/gandi"
    }
  }
  required_version = ">= 0.14"
}

provider "openstack" {
  alias               = "sto1-sandbox"
  cloud = "safespring-sto1"
}


provider "openstack" {
  alias = "psnc-dcw"
  cloud = "psnc-dcw"
  region = "DCW"
}
