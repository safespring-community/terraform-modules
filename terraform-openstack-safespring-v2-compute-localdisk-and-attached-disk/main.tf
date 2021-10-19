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

resource "openstack_blockstorage_volume_v3" "safespring_local_disk_vol" {
  name  = "${var.prefix}-${count.index+1}.${var.domain_name}-vol"
  count = var.instance_count
  size  = var.volume_size
}

resource "openstack_compute_volume_attach_v2" "safespring_local_disk_attach_vol" {
  instance_id = element(openstack_compute_instance_v2.safespring_local_disk.*.id,count.index)
  volume_id   = element(openstack_blockstorage_volume_v3.safespring_local_disk_vol.*.id,count.index)
  count = var.instance_count
}
