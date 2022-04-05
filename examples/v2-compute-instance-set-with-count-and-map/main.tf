locals {
  instances = {
    "web" = {
      prefix  = "web"
      flavor  = "l2.c2r4.100"
      os      = "centos-7"
      network = "public"
      i_count   = 2
    }
    "db" = {
      prefix  = "db"
      flavor  = "l2.c4r8.100"
      network = "default"
      os      = "ubuntu-20.04"
      data_disks = {
        "db" = {
          size    = 5
          type    = "fast"
        }
      }
    }
  }
}

module my_sf_instances {
   for_each        = local.instances
   source          = "./a-set-of-instances"
   prefix          = each.value.prefix
   i_count         = try(each.value.i_count,1)
   image           = each.value.os
   network         = each.value.network
   flavor          = each.value.flavor
   key_pair_name   = "jb-jump"
   data_disks      = try(each.value.data_disks,{})
}
