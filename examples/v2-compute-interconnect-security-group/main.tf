# See ../../v2-compute-interconnect-security-group/variables.tf for 
# possible values and descriptions

module puff {
   source = "../../v2-compute-interconnect-security-group"
   # source = "github.com/safespring-community/terraform-modules/v2-compute-interconnect-security-group"
   name = "slartibartfast"
   description = "Don't panic!"
}

