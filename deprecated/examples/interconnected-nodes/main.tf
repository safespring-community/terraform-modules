# A self contained example on a complete infra using only modules with parameters (and a keypair which hardly is worth
# putting in module :_)) 
#


# If you use openstack resources directly here (like keypair under here) the provider-config must also be included 
# for this file

terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
  }
}
# Create a keypair from a public key.
# Used to inject into instances by back refernce

resource "openstack_compute_keypair_v2" "skp" {
  name       = "my-interconnected-infra"
  public_key = "${chomp(file("~/.ssh/id_rsa.pub"))}"
}

# Security group for the public facing host
# Allows ingress for ssh from one IPv4
# allows ping from the world

module public_sg {
   source = "github.com/safespring-community/terraform-modules/v2-compute-security-group"
   name = "cluster_jump_sg"
   description = "External access"
   rules = [
     {
       ip_protocol = "tcp"
       to_port = "22"
       from_port = "22"
       cidr = "37.191.250.83/32"
     },
     {
       ip_protocol = "icmp"
       to_port = "-1"
       from_port = "-1"
       cidr = "0.0.0.0/0"
     }

   ]
}

module interconnect {
   #source = "github.com/safespring-community/terraform-modules/v2-compute-interconnect-security-group"
    source = "../../v2-compute-interconnect-security-group"
   name = "cluster-interconnect"
   description = "All members have full tcp and udp access to each other"
}

# Cluster nodes on the private net
module  cluster_nodes {
  source = "github.com/safespring-community/terraform-modules/v2-compute-local-disk-and-attached-disk"
  key_pair_name = openstack_compute_keypair_v2.skp.name
  security_groups = [module.interconnect.id]
  instance_count = 2
  prefix = "cluster-test"
  network = "private"
  volume_size = 7
  image = "centos-7"
  flavor = "lb.tiny"
}

# Jump node for accessing cluster nodes on the private net
# thus member of both the security group for external facing sevices (ssh, icmp) and the 
# inter-cluster security group for full access to cluster nodes
# add more modules for more iinterconnected groups of server that will be isolated from each other
# If jump host becomes member of those security groups the jumphost have full network access to all private 
# servers but each group only have access to instancese in the same group

module public_node {
  source = "github.com/safespring-community/terraform-modules/v2-compute-local-disk"
  key_pair_name = openstack_compute_keypair_v2.skp.name
  security_groups = [module.public_sg.id,module.interconnect.id]
  instance_count = 1
  prefix = "cluster-jump"
  network = "public"
  flavor = "lb.small"
}
