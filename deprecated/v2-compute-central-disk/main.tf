data "openstack_images_image_v2" "image" {
  name        = var.image
  most_recent = true
}

resource "openstack_compute_instance_v2" "safespring_central_disk" {
  name       = "${var.prefix}-${count.index+1}.${var.domain_name}"
  count      = var.instance_count
  image_name = var.image
  flavor_name  = var.flavor
  key_pair   = var.key_pair_name

  network {
    name = var.network
  }
  block_device {
    uuid                  = data.openstack_images_image_v2.image.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = var.root_disk_size
    delete_on_termination = true
  }

  security_groups = var.security_groups
  metadata = {
    role = var.role
  }
}

