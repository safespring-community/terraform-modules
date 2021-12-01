variable "base_image_id" {
  type        = string
  description = "The identifier of the Glance image for worker nodes."
}

variable "cluster_name" {}
variable "domain_name" {}

variable "flavor_name" {
  type = string
}

variable "instance_count" {
  type = string
}

variable "worker_sg_names" {
  type        = list(string)
  default     = ["default"]
}

variable "user_data_ign" {
  type = string
}

variable "network_name" {}
variable "worker_volume_size" {}
