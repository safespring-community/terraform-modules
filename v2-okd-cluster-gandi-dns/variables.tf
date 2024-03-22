variable "dns_enable" {
  type        = number
  description = "DNS enable"
}

variable "lb_image_name" {
  type        = string
  description = "Image name for loadbalancer"
}

variable "lb_ssh_pubkey_path" {
  type        = string
  description = "Full path of loadbalnacer ssh public key"
}

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

variable "number_of_boot" {
  default = 0
}

variable "number_of_masters" {
  default = 3
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
  type        = map(object({
    prefix    = string
    flavor    = string
    count     = number
    disk_size = number
  }))
  default = {}
#  default = {
#    "first" = {
#      prefix = "medium"
#      flavor = "lm.medium.1d"
#      count = 2
#      disk_size = 0
#    }
#    "second" = {
#      prefix = "cinder-large"
#      flavor = "m.large"
#      count = 2
#      disk_size = 70
#    }
#  }
}
