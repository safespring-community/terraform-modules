data "openstack_compute_flavor_v2" "workers_flavor" {
  name = var.flavor_name
}

data "ignition_file" "hostname" {
  count = var.instance_count
  mode  = "420" // 0644
  path  = "/etc/hostname"

  content {
    content = <<EOF
${var.prefix}-${count.index+1}-${var.cluster_name}.${var.domain_name}
EOF
  }
}

#data "ignition_filesystem" "vdb" {
#  # Trigger this only for l-flavors
#  for_each = local.disk_devices
##  device = "/dev/vdb"
#  format = "xfs"
#  wipe_filesystem = true
#  path = "/var/lib/containers"
#}

#data "ignition_systemd_unit" "var_lib_containers" {
#  for_each = local.disk_devices
#  name = "var-lib-containers.mount"
#  content = <<EOF
#[Unit]
#Description=Mount /var/lib/containers
#Before=local-fs.target
#
#[Mount]
#What=/dev/vdb
#Where=/var/lib/containers
#Type=xfs

#[Install]
#WantedBy=local-fs.target
#EOF
#}

resource "openstack_compute_servergroup_v2" "servergroup" {
  name     = "${var.cluster_name}-workers"
  policies = [ "soft-anti-affinity" ]
}

data "ignition_config" "worker_ignition_config" {
  count = var.instance_count

  merge {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(var.user_data_ign)}"
  }

  files = [
    element(data.ignition_file.hostname.*.rendered, count.index)
  ]
#  filesystems = [
#    # List of all instances of data.ignition_filesystem.vdb , which means either one (dummy) or none
#    for i in local.disk_devices : data.ignition_filesystem.vdb[i].rendered
#  ]
#  systemd = [
#    # List of all instances of data.ignition_systemd_unit.var_lib_containers, which means either one (dummy) or none
#    for i in local.disk_devices : data.ignition_systemd_unit.var_lib_containers[i].rendered
#  ]
}

# Some intellegence wrt to setting correct disk size based on flavor
locals {
  # If no disk size was specified in workerset, set it to 30, otherwise set it to the specified number
  var_disk_size = var.disk_size < 50 ? 50 : var.disk_size
  # Set disk size to 0 if flavor with local disk (starts with l), otherwise set it to the value of var_disk_size
  disk_size = length(regexall("^l.*", var.flavor_name)) > 0 ? 0 : local.var_disk_size
  # Create list with one item  if local disk flavor, else create an empty list.
  disk_devices = toset(length(regexall("^l.*", var.flavor_name)) > 0 ? ["dummy"]: [])
}

resource "openstack_compute_instance_v2" "k8s_worker" {
  name = "${var.prefix}-${count.index+1}-${var.cluster_name}.${var.domain_name}"
  count = var.instance_count
  tags = []

  flavor_id = data.openstack_compute_flavor_v2.workers_flavor.id
  image_id = var.base_image_id
  security_groups = var.worker_sg_names
  user_data = element(
    data.ignition_config.worker_ignition_config.*.rendered,
    count.index,
  )
  dynamic "block_device" {
    # Trick terraform to add block device only when disk_size is > 0
    for_each = local.disk_size > 0 ? [var.base_image_id] : []
    content {
      uuid                  = var.base_image_id
      source_type           = "image"
      volume_size           = local.disk_size
      destination_type      = "volume"
      delete_on_termination = true
      boot_index            = 0
    }
  }

  scheduler_hints {
    group = openstack_compute_servergroup_v2.servergroup.id
  }

  network {
    name = var.network_name
  }

  metadata = {
    role             = "worker"
    cluster_name     = "${var.cluster_name}.${var.domain_name}"
  }
}
