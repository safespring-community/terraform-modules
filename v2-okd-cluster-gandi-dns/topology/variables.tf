variable "cluster_name" {
  type    = string
  default = "example"
}

variable "allow_ssh_from_v4" {
  type = list(string)
  default = []
}

variable "allow_api_from_v4" {
  type = list(string)
  default = []
}

variable "allow_all_ports_from_v4" {
  type = list(string)
  default = []
}
