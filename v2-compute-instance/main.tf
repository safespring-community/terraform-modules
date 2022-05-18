data "openstack_images_image_v2" "image" {
  name        = var.image
  most_recent = true
}

# Some intelligence wrt to setting correct disk size based on flavor
# If non-local-diks-flavor we assume the minimum is 5GB
# If local-disk-flavor size is forced to 0 which in turn disables provisioning of a central disk.
locals {
  var_disk_size = var.disk_size < 5 ? 5 : var.disk_size
  # Set disk size to 0 if flavor with local disk (starts with l), otherwise set it to the value of var_disk_size
  disk_size = length(regexall("^l.*", var.flavor)) > 0 ? 0 : local.var_disk_size
}

resource "openstack_compute_instance_v2" "safespring_instance" {
  name         = var.name
  image_name   = var.image
  flavor_name  = var.flavor
  key_pair     = var.key_pair_name
  config_drive = var.config_drive

  dynamic "scheduler_hints" {
    for_each = var.servergroup_id != "" ? ["dummy_element"] : []
    content {
      group = var.servergroup_id
    }
  }
  network {
    name = var.network
  }

  security_groups = var.security_groups

  metadata = {
    role = var.role
    wg_ip = var.wg_ip
  }

  dynamic "block_device" {
    # Trick terraform to add block device only when disk_size is > 0
    for_each = local.disk_size > 0 ? ["dummy_element"] : []
    content {
      uuid                  = data.openstack_images_image_v2.image.id
      source_type           = "image"
      volume_size           = local.disk_size
      destination_type      = "volume"
      delete_on_termination = true
      boot_index            = 0
    }
  }
}

resource "openstack_blockstorage_volume_v3" "safespring_vol" {
  for_each = var.data_disks
  name  = "${var.name}-vol"
  size  = each.value.size
  volume_type = each.value.type
}

resource "openstack_compute_volume_attach_v2" "safespring_vol_attach" {
  for_each = var.data_disks
  instance_id = openstack_compute_instance_v2.safespring_instance.id
  volume_id   = openstack_blockstorage_volume_v3.safespring_vol[each.key].id
}
