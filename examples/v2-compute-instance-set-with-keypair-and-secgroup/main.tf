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
  public_key = "${chomp(file("~/.ssh/id_rsa.pub"))}"
}

# Create a security group using a safespring module
module puff {
   source = "github.com/safespring-community/terraform-modules/v2-compute-security-group"
   name = "bowl-of-petunias"
   description = "Oh no! Not again"
   rules = [
     {
       ip_protocol = "tcp"
       to_port = "80"
       from_port = "80"
       cidr = "0.0.0.0/0"
     },
     {
       ip_protocol = "tcp"
       to_port = "443"
       from_port = "443"
       cidr = "0.0.0.0/0"
     }

   ]
}

module my_sf_instances {
   source          = "github.com/safespring-community/terraform-modules/v2-compute-instance"
   name            = "hello-safespring-${count.index + 1}.example.com"
   count           = 3
   security_groups = [ module.puff.name ]
   key_pair_name   = openstack_compute_keypair_v2.skp.name
}
