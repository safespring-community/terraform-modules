variable "affinity" {
  type        = string
  description = "Affinity for masters. Choose between anti-affinity (hard) and soft-anti-affinity "
}
variable "base_image_id" {
  type        = string
  description = "The identifier of the Glance image for master nodes."
}

variable "cluster_name" {}
variable "domain_name" {}

variable "flavor_name" {
  type = string
}

variable "instance_count" {
  type = string
}

variable "master_sg_names" {
  type        = list(string)
  default     = ["default"]
  description = "The security group IDs to be applied to the master nodes."
}

variable "user_data_ign" {
  type = string
}

variable "network_name" {}
