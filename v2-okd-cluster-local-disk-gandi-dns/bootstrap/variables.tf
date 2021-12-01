variable "base_image_id" {
  type        = string
  description = "The identifier of the Glance image for the bootstrap node."
}

variable "cluster_name" {}
variable "domain_name" {}

variable "bootstrap_shim_ignition" {
  type = string
}

variable "flavor_name" {
  type = string
  description = "The Nova flavor for the bootstrap node."
}

variable "instance_count" {
  type = string
}

variable "network_name" {}

variable "master_sg_names" {
  type        = list(string)
  default     = ["default"]
  description = "The security group IDs to be applied to the master nodes."
}
