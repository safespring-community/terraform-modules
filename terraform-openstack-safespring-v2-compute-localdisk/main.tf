resource "openstack_compute_instance_v2" "safespring_local_disk" {
  name       = "${var.prefix}-${count.index+1}.${var.domain_name}"
  count      = var.instance_count
  image_name = var.image
  flavor_name  = var.flavor
  key_pair   = var.key_pair_name

  network {
    name = var.network
  }

  security_groups = var.security_groups
  metadata = {
    role = var.role
  }
}

