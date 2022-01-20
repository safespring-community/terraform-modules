variable "base_image_id" {
  type        = string
  description = "The identifier of the Glance image for worker nodes."
}

variable "lb_disk_size" {
  type = number
  default = 20
}

variable "cluster_name" {}
variable "domain_name" {}

variable "flavor_name" {
  type = string
}

variable "network_name" {}
variable "ssh_user" {}

variable "number_of_boot" {}

variable "loadbalancer_sg_names" {
  type        = list(string)
  default     = ["default"]
}

variable "ssh_public_key_path" {}

variable "api_backend_addresses" {
  type = list(string)
}

variable "ingress_backend_addresses" {
  type = list(string)
}
