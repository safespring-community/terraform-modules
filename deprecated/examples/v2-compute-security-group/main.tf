# See ../../v2-compute-security-group/variables.tf for 
# possible values and descriptions

module puff {
   # source = "../../v2-compute-security-group"
   source = "github.com/safespring-community/terraform-modules/v2-compute-security-group"
   name = "thanksforallthefish"
   description = "Oh no! Not again"
   rules = [
     {
       ip_protocol = "udp"
       to_port = "666"
       from_port = "666"
       cidr = "8.8.8.8/32"
     },
     {
       ip_protocol = "tcp"
       to_port = "666"
       from_port = "666"
       cidr = "1.1.1.1/32"
     }
     
   ]
}

