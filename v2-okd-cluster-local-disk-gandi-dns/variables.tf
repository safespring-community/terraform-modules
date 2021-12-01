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

variable "number_of_workers" {
  default = 2
}

variable "worker_volume_size" {
  default = 15
}

variable "master_volume_size" {
  default = 20
}

variable "node_volume_size" {
  default = 20
}

variable "image_lb" {
  description = "the image to use (LB)"
  default     = "GOLD CentOS 7"
}
variable "image" {
  description = "the image to use (cluster)"
  default     = "fedora-coreos-31.20200118.3.0"
}

variable "openstack_loadbalancer_flavor_name" {
  type = string
  description = "Instance size for the loadbalancer node. Example: `m1.medium`."
}

variable "openstack_master_flavor_name" {
  type = string
  description = "Instance size for the master node(s). Example: `m1.medium`."
}

variable "openstack_worker_flavor_name" {
  type = string
  description = "Instance size for the worker node(s). Example: `m1.large`."
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
