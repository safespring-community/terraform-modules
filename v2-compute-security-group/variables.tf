variable "rules" {
  type = list(map(string))
  default = [
    {
      "ip_protocol" = "icmp"
      "from_port" = -1
      "to_port" = -1
      "cidr" = "0.0.0.0/0"
    }
  ]
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
