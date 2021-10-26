# See ../../v2-compute-localdisk/variables.tf for 
# possible values and descriptions

module my_sf_instances_tiny_a_set {
  # source = "../../v2-compute-localdisk"
  source = "github.com/safespring-community/terraform-modules/v2-compute-localdisk"
  # key_pair_name = "an-existing-keypair"
  # security_groups = ["some-existing","secgroups"]
}

module my_sf_instances_another_set{
  # source = "../../v2-compute-localdisk"
  source = "github.com/safespring-community/terraform-modules/v2-compute-localdisk"
  # key_pair_name = "an-existing-keypair"
  # security_groups = ["some-existing","secgroups"]
  instance_count = 2
  image = "centos-7"
  flavor = "lb.tiny"
}

output "instance_ip_addr" {
  value       = module.my_sf_instances_another_set.IPv4
  description = "The IPv4 addresses"
}
