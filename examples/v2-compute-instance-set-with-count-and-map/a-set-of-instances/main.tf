# See variables.tf for 
# possible values and descriptions


module my_sf_instances {
   source          = "github.com/safespring-community/terraform-modules/v2-compute-instance"
   name            = "${var.prefix}-${count.index + 1}.example.com"
   count           = var.i_count
   key_pair_name   = var.key_pair_name
   data_disks      = var.data_disks
   image           = var.image
   network         = var.network
   flavor          = var.flavor
}

