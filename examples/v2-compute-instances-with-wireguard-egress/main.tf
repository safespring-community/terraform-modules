terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
  }
}

# Create a keypair from a public key.
# An openstack keypair contains only the public key. Thus a misleading name for it.
resource "openstack_compute_keypair_v2" "skp" {
  name       = "hello-pubkey"
  public_key = "${chomp(file("~/.ssh/id_rsa_jump.pub"))}"
}

module interconnect {
   source = "github.com/safespring-community/terraform-modules/v2-compute-security-group"
   name = "interconnect"
   delete_default_rules = true
   description = "For interconnecting servers with full network access between members"
   rules = {
     ingress = {
       direction       = "ingress"
       remote_group_id = "self"
     }
     egress = {
       direction       = "egress"
       remote_group_id = "self"
     }
  }
}

module ingress {
   source = "github.com/safespring-community/terraform-modules/v2-compute-security-group"
   name = "ingress"
   delete_default_rules = true
   description = "For exposing web servers on port 443 (https) to the world"
   rules = {
     egress = {
       direction   = "egress"
       ethertype   = "IPv4"
       cidr        = "0.0.0.0/0"
     }
     ssh = {
       direction   = "ingress"
       ip_protocol = "tcp"
       to_port     = "22"
       from_port   = "22"
       ethertype   = "IPv4"
       cidr        = "0.0.0.0/0"
     }
  }
}

module my_gw {
   source          = "github.com/safespring-community/terraform-modules/v2-compute-instance"
   name            = "wireguard-gw.example.com"
   image           = "ubuntu-20.04"
   network         = "public"
   security_groups = [ module.interconnect.name, module.ingress.name ]
   role            = "wg_gw"
   wg_ip           = "192.168.45.1"
   key_pair_name   = openstack_compute_keypair_v2.skp.name
}

module my_clients {
   source          = "github.com/safespring-community/terraform-modules/v2-compute-instance"
   count           = 2
   name            = "wireguard-client-${count.index+1}.example.com"
   image           = "ubuntu-20.04"
   network         = "public"
   security_groups = [ module.interconnect.name, module.ingress.name ]
   role            = "wg_client"
   wg_ip           = cidrhost("192.168.45.0/24",count.index + 2)
   key_pair_name   = openstack_compute_keypair_v2.skp.name
}
