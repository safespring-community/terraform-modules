# See variables.tf for 
# possible values and descriptions

module my_sf_instance {
   source = "github.com/safespring-community/terraform-modules/v2-compute-instance"
   # name          = "pangalactic-gargleblaster"
   # key_pair_name = "your-keypair"
   # config_drive  = false
   # disk_size     = 5                 # When using b2-flavors
   # network       = "default"         # One of default, private, public
   # role          = "general"         # Ends up as metadata. Can be for example be used as ansible host group with Ansible Terraform Inventory (ATI)
   # image         = "ubuntu-20.04"
   # flavor        = "l2.c2r4.100"     # Use openstack flavor list. Pick flavors starting with b2 or l2 
   # security_groups = ["default"]
   # data_disks = {
   #   "db" = {
   #     size    = 5
   #     type    = "fast"
   #   }
   #   "archive" = {
   #      size = 10
   #      type = "large"
   #   }
   # }
}

#output "instance_ip_addr" {
#  value       = module.my_sf_instance.IPv4
#  description = "the ipv4 address"
#}
#
#output "instance_ipv6_addr" {
#  value       = module.my_sf_instance.IPv6
#  description = "the ipv6 address"
#}
