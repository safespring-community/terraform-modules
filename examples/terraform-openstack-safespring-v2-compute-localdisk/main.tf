# See ../../terraform-openstack-safespring-v2-compute-localdisk/variables.tf for 
# possible values and descriptions

module my_sf_instances_tiny_a_set {
  source = "../../terraform-openstack-safespring-v2-compute-localdisk"
  key_pair_name = "jarleb"
}

module my_sf_instances_another_set{
  source = "../../terraform-openstack-safespring-v2-compute-localdisk"
  key_pair_name = "jarleb"
  instance_count = 2
  image = "centos-7"
  flavor = "lb.tiny"
}
