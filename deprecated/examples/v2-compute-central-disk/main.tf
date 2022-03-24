# See ../../v2-compute-localdisk/variables.tf for 
# possible values and descriptions

module my_sf_instances_tiny_a_set {
   #source = "../../v2-compute-central-disk"
   source = "github.com/safespring-community/terraform-modules/v2-compute-central-disk"
  # key_pair_name = "an-existing-keypair"
  # security_groups = ["some-existing","secgroups"]
   flavor = "b.tiny"
}

