module "loadbalancer" {
  source                    = "./loadbalancer"
  dns_enable                = var.dns_enable
  image_id                  = data.openstack_images_image_v2.lb_image.id
  cluster_name              = var.cluster_name
  domain_name               = var.domain_name
  flavor_name               = var.openstack_loadbalancer_flavor_name
  ssh_pubkey_path           = var.lb_ssh_pubkey_path
  network_name              = var.lb_network_name
  loadbalancer_sg_names     = module.topology.loadbalancer_sg_names
}

module "bootstrap" {
  source                  = "./bootstrap"
  base_image_id           = data.openstack_images_image_v2.base_image.id
  cluster_name            = var.cluster_name
  domain_name             = var.domain_name
  flavor_name             = var.openstack_master_flavor_name
  instance_count          = var.number_of_boot
  network_name            = var.network_name
  master_sg_names         = module.topology.master_sg_names
  bootstrap_shim_ignition = var.openstack_bootstrap_shim_ignition
}

module "masters" {
  source          = "./masters"
  dns_enable      = var.dns_enable
  base_image_id   = data.openstack_images_image_v2.base_image.id
  cluster_name    = var.cluster_name
  domain_name     = var.domain_name
  affinity        = var.master_affinity
  flavor_name     = var.openstack_master_flavor_name
  instance_count  = var.number_of_masters
  network_name    = var.network_name
  user_data_ign   = var.ignition_master
  master_sg_names = module.topology.master_sg_names
}

module "workers" {
  source           = "./workers"
  for_each         = var.workersets
  base_image_id    = data.openstack_images_image_v2.base_image.id
  cluster_name     = var.cluster_name
  domain_name      = var.domain_name
  workerset_key    = each.key
  flavor_name      = each.value.flavor
  instance_count   = each.value.count
  disk_size        = each.value.disk_size
  prefix           = each.value.prefix
  network_name     = var.network_name
  user_data_ign    = var.ignition_worker
  worker_sg_names  = module.topology.worker_sg_names
}

module "topology" {
  source                  = "./topology"
  cluster_name            = var.cluster_name
  allow_ssh_from_v4       = var.allow_ssh_from_v4
  allow_api_from_v4       = var.allow_api_from_v4
  allow_all_ports_from_v4 = var.allow_all_ports_from_v4
}

data "openstack_images_image_v2" "base_image" {
  name = var.openstack_base_image_name
  most_recent = true
}

data "openstack_images_image_v2" "lb_image" {
  name = var.lb_image_name
  most_recent = true
}
