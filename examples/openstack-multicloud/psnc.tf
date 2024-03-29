
resource "openstack_compute_keypair_v2" "psncdcwkp" {
  name       = "mc-psnc-bst-pubkey"
  public_key = chomp(file("~/.ssh/id_ecdsa.pub"))
  provider   = openstack.psnc-dcw
}

module "psnc_dcw_http_backend_sg" {
  providers = {
    openstack = openstack.psnc-dcw
  }
  source      = "github.com/safespring-community/terraform-modules/v2-compute-security-group"
  name        = "http_back_end"
  description = "Opening ports for http backends"
  rules = {
    one = {
      ip_protocol = "tcp"
      to_port     = "22"
      from_port   = "22"
      ethertype   = "IPv4"
      cidr        = "0.0.0.0/0"
    }
    two = {
      ip_protocol = "tcp"
      to_port     = "443"
      from_port   = "443"
      ethertype   = "IPv4"
      cidr        = "0.0.0.0/0"
    }
    three = {
      ip_protocol = "tcp"
      to_port     = "80"
      from_port   = "80"
      ethertype   = "IPv4"
      cidr        = "0.0.0.0/0"
    }
    four = {
      ip_protocol = "icmp"
      ethertype   = "IPv4"
      cidr        = "0.0.0.0/0"
    }
  }
}

module "psnc_dcw_instances" {
  providers = {
    openstack = openstack.psnc-dcw
  }
  source          = "github.com/safespring-community/terraform-modules/v2-compute-instance"
  name            = "mc-psnc-dcw-${count.index + 1}.saft.in"
  role            = "http_backend"
  count           = var.count_psnc
  disk_size       = 30
  network         = "jbnet"
  flavor          = "s.2VCPU_4GB"
  image           = "Ubuntu Server 22.04 LTS Cloud Image"
  security_groups = [module.psnc_dcw_http_backend_sg.name]
  key_pair_name   = openstack_compute_keypair_v2.psncdcwkp.name
}


resource "openstack_networking_floatingip_v2" "floatip_1" {
  provider = openstack.psnc-dcw
  count    = var.count_psnc
  pool     = "PCSS-DCW-PUB1-EDU"
}

resource "openstack_compute_floatingip_associate_v2" "fipa_1" {
  provider    = openstack.psnc-dcw
  count       = var.count_psnc
  floating_ip = openstack_networking_floatingip_v2.floatip_1[count.index].address
  instance_id = module.psnc_dcw_instances[count.index].id
}
