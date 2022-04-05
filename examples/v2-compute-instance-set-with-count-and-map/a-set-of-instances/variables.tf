variable "i_count" {
  description = "Count"
  type        = number
}

variable "flavor" {
  description = "Openstack instance flavor. (One of openstack ‹openstack flavor list -f json | jq -r '.[].Name'|grep ^l›)"
  type        = string
}

variable "prefix" {
  description = "prefix"
  type        = string
}

variable "key_pair_name" {
  description = "Name of ssh keypair to use. Must exist in the project"
  type = string
}

variable "image" {
  description = "Image name to base the instance on. One of: ‹openstack image list›"
  type = string
}

variable "network" {
  description = "Network to place instance on. One of: ‹openstack network list›"
  type = string
}


variable "data_disks" {
  type        = map(
    object({
      type      = string
      size      = number
    })
  )
}

