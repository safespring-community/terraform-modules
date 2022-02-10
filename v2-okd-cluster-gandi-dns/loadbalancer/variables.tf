variable "ssh_pubkey_path" {
  type        = string
  description = "Full path of the ssh public key file"
}

variable "image_id" {
  type        = string
  description = "Image id"
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

variable "loadbalancer_sg_names" {
  type        = list(string)
  default     = ["default"]
}
