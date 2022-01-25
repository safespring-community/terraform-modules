module "loadbalancer" {
  source = "./loadbalancer"

  base_image_id  = data.openstack_images_image_v2.base_image.id
  cluster_name   = var.cluster_name
  domain_name    = var.domain_name
  flavor_name    = var.openstack_loadbalancer_flavor_name
  network_name   = var.network_name

  ssh_user       = var.ssh_user
  number_of_boot = var.number_of_boot

  loadbalancer_sg_names = module.topology.loadbalancer_sg_names

  ssh_public_key_path = var.public_key_path

  api_backend_addresses = flatten([
    module.bootstrap.ip_addresses[0],
    module.masters.ip_addresses]
  )
  ingress_backend_addresses = flatten([for i in keys(var.workersets) : module.workers[i].ip_addresses])
}

module "bootstrap" {
  source = "./bootstrap"

  base_image_id  = data.openstack_images_image_v2.base_image.id
  cluster_name   = var.cluster_name
  domain_name    = var.domain_name
  flavor_name    = var.openstack_master_flavor_name
  instance_count = var.number_of_boot
  network_name   = var.network_name


  master_sg_names = module.topology.master_sg_names
  bootstrap_shim_ignition = var.openstack_bootstrap_shim_ignition
}

module "masters" {
  source = "./masters"

  base_image_id   = data.openstack_images_image_v2.base_image.id
  cluster_name    = var.cluster_name
  domain_name     = var.domain_name
  flavor_name     = var.openstack_master_flavor_name
  instance_count  = var.number_of_masters
  network_name    = var.network_name
  user_data_ign   = var.ignition_master

  master_volume_size = var.master_volume_size


  master_sg_names = module.topology.master_sg_names
}

module "workers" {
  source = "./workers"
  for_each        = var.workersets
  base_image_id   = data.openstack_images_image_v2.base_image.id
  cluster_name    = var.cluster_name
  domain_name     = var.domain_name
  flavor_name     = each.value.flavor
  instance_count  = each.value.count
  prefix          = each.value.prefix
  network_name    = var.network_name
  user_data_ign   = var.ignition_worker

  worker_volume_size = var.worker_volume_size


  worker_sg_names = module.topology.worker_sg_names
}

module "topology" {
  source = "./topology"

  cluster_name      = var.cluster_name
  allow_ssh_from_v4 = var.allow_ssh_from_v4
  allow_api_from_v4 = var.allow_api_from_v4
  allow_all_ports_from_v4 = var.allow_all_ports_from_v4
}

data "openstack_images_image_v2" "base_image" {
  name = var.openstack_base_image_name
}
