variable "master_affinity" {
  type        = string
  description = "Affinity for masters. Choose between anti-affinity (hard) and soft-anti-affinity "
  default     = "soft-anti-affinity"
}

variable "openstack_base_image_name" {
  type        = string
  description = "Name of the base image to use for the nodes."
}

variable "openstack_bootstrap_shim_ignition" {
  type        = string
  default     = ""
  description = "Generated pointer/shim ignition config with user ca bundle."
}

variable "ignition_master" {
  type = string
  default = ""
}

variable "ignition_worker" {
  type = string
  default = ""
}

variable "cluster_name" {
  default = "example"
}

variable "public_key_path" {
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_user" {
  default = "centos"
}

variable "number_of_boot" {
  default = 0
}

variable "number_of_masters" {
  default = 3
}

variable "worker_volume_size" {
  default = 15
}

variable "master_volume_size" {
  default = 20
}

variable "openstack_loadbalancer_flavor_name" {
  type = string
  description = "Instance size for the loadbalancer node. Example: `m1.medium`."
  default = "m.small"
}

variable "openstack_master_flavor_name" {
  type = string
  description = "Instance size for the master node(s). Example: `m1.medium`."
}

variable "network_name" {
  description = "name of the internal network to use"
  default     = "dualstack"
}

variable "domain_name" {
  description = "DNS domain name"
  default     = "example.uiocloud.no"
}

variable "allow_ssh_from_v4" {
  type = list(string)
  default = []
}

variable "allow_all_ports_from_v4" {
  type = list(string)
  default = []
}

variable "allow_api_from_v4" {
  type = list(string)
  default = []
}


# Worker sets
variable "workersets" {
  type = map(object({
    prefix  = string
    flavor  = string
    count   = number
  }))
  default = {}
#  default = {
#    "first" = {
#      prefix = "medium"
#      flavor = "lm.medium.1d"
#      count = 2
#    }
#    "second" = {
#      prefix = "large"
#      flavor = "lm.large.1d"
#      count = 2
#    }
#  }
}
