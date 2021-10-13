variable "flavor" {
  description = "Openstack instance flavors with local disk. (One of openstack ‹openstack flavor list -f json | jq -r '.[].Name'|grep ^l›)"
  type        = string
  default     = "lb.small"
}

variable "prefix" {
  description = "Name prefix"
  type        = string
  default     = "hello-safespring"
}

variable "domain_name" {
  description = "Domain name (suffix)"
  type        = string
  default     = "localnet"
}

variable "instance_count" {
  description = "Instance count. How many instances"
  type        = number
  default     = 1
}

variable "role" {
  description = "Instance role. Ends up in metadata and can be used as ansible inventory group"
  type = string
  default = "general"
}

variable "key_pair_name" {
  description = "Name of ssh keypair to use. Must exist in the project"
  type = string
}

variable "image" {
  description = "Image name to base the instance on. One of: ‹openstack image list›"
  type = string
  default = "ubuntu-20.04"
}

variable "network" {
  description = "Network to place instance on. One of: ‹openstack network list›"
  type = string
  default = "public"
}

variable "security_groups" {
  description = "List of security groups to be member of."
  type = list
  default = [ "default" ]
}
