# See ../../terraform-openstack-safespring-v2-compute-localdisk/variables.tf for 
# possible values and descriptions

module my_sf_instances_tiny_a_set {
  source = "../../terraform-openstack-safespring-v2-compute-localdisk-and-attached-disk"
  #source = "github.com/safespring-community/terraform-modules/terraform-openstack-safespring-v2-compute-localdisk-and-attached-disk"
  # key_pair_name = "an-existing-keypair"
  # security_groups = ["some-existing","secgroups"]
  volume_size = 5
}

module my_sf_instances_another_set{
  source = "../../terraform-openstack-safespring-v2-compute-localdisk-and-attached-disk"
  #source = "github.com/safespring-community/terraform-modules/terraform-openstack-safespring-v2-compute-localdisk-and-attached-disk"
  # key_pair_name = "an-existing-keypair"
  # security_groups = ["some-existing","secgroups"]
  instance_count = 2
  volume_size = 7
  image = "centos-7"
  flavor = "lb.tiny"
}

output "instance_ip_addr" {
  value       = module.my_sf_instances_another_set.IPv4
  description = "The IPv4 addresses"
}
