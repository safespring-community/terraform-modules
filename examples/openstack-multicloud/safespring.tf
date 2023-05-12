resource "openstack_compute_keypair_v2" "sto1kp" {
  name       = "mc-sto1-pubkey"
  public_key = chomp(file("~/.ssh/id_rsa_jump.pub"))
  provider   = openstack.sto1-sandbox
}

module "sto1_http_backend_sg" {
  providers = {
    openstack = openstack.sto1-sandbox
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
  }
}

module "sto1_instances" {
  providers = {
    openstack = openstack.sto1-sandbox
  }
  source          = "github.com/safespring-community/terraform-modules/v2-compute-instance"
  name            = "mc-safespring-sto1-${count.index + 1}.saft.in"
  role            = "http_backend"
  count           = 2
  network         = "public"
  security_groups = [module.sto1_http_backend_sg.name]
  key_pair_name   = openstack_compute_keypair_v2.sto1kp.name
}

