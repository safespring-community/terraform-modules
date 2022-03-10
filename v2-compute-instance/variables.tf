variable "wg_ip" {
  description = "Wireguard IP. To be used with as inventory to allocate a potential wg addresse for this peer"
  type        = string
  default     = ""
}

variable "config_drive" {
  description = "Use config drive or not: default = false"
  type        = bool
  default     = false
}

variable "disk_size" {
  description = "Disk size if instance is with central disk"
  type        = number
  default     = 0
}

variable "flavor" {
  description = "Openstack instance flavors with local disk. (One of openstack ‹openstack flavor list -f json | jq -r '.[].Name'|grep ^l›)"
  type        = string
  default     = "b2.c1r2"
}

variable "name" {
  description = "Instance name"
  type        = string
  default     = "hello-safespring"
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

variable "data_disks" {
  type        = map(
    object({
      type      = string
      size      = number
    })
  )
  default = {}
}

