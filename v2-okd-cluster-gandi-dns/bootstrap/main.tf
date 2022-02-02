data "openstack_compute_flavor_v2" "bootstrap_flavor" {
  name = var.flavor_name
}

resource "openstack_compute_instance_v2" "bootstrap" {
  name            = "boot-${var.cluster_name}.${var.domain_name}"
  flavor_id       = data.openstack_compute_flavor_v2.bootstrap_flavor.id
  count           = var.instance_count
  image_id        = var.base_image_id
  security_groups = var.master_sg_names
  user_data = var.bootstrap_shim_ignition

  network {
    name = var.network_name
  }

  metadata = {
    role             = "boot"
  }
}

resource "gandi_livedns_record" "boot_instance" {
  zone        = var.domain_name
  name        = "boot-${var.cluster_name}"
  count       = var.instance_count
  ttl         = 300
  type        = "A"
  values      = [element(openstack_compute_instance_v2.bootstrap.*.access_ip_v4,count.index)]
}
