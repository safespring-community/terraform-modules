variable "rules" {
  description = "Map of maps describing rules"
  type = map(map(string))
}

variable "name" {
  description = "Name of the secuirty group"
  type = string
  default = "puffoflogic"
}

variable "description" {
  description = "Description of the description of the security group ;-)"
  type = string
  default = "Quod erat demonstrandum"
}

variable "delete_default_rules" {
  description = "Should the default rules added by openstack be remover "
  type = bool
  default = false
}
