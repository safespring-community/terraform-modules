
data "openstack_compute_flavor_v2" "masters_flavor" {
  name = var.flavor_name
}

data "ignition_file" "hostname" {
  count = var.instance_count
  mode  = "420" // 0644
  path  = "/etc/hostname"

  content {
    content = <<EOF
master-${count.index+1}-${var.cluster_name}.${var.domain_name}
EOF
  }
}
#data "ignition_filesystem" "vdb" {
#  device = "/dev/vdb"
#  format = "xfs"
#  wipe_filesystem = true
#  path = "/var/lib/containers"
#}

#data "ignition_systemd_unit" "var_lib_containers" {
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
#
#[Install]
#WantedBy=local-fs.target
#EOF
#}

data "ignition_config" "master_ignition_config" {
  count = var.instance_count

  merge {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(var.user_data_ign)}"
  }

  files = [
    element(data.ignition_file.hostname.*.rendered, count.index)
  ]
#  filesystems = [
#    data.ignition_filesystem.vdb.rendered
#  ]
#  systemd = [
#    data.ignition_systemd_unit.var_lib_containers.rendered
#
#  ]
}
resource "openstack_compute_servergroup_v2" "servergroup" {
  name     = "${var.cluster_name}-masters"
  policies = [ var.affinity ]
}

resource "openstack_compute_instance_v2" "master_conf" {
  name = "master-${count.index+1}-${var.cluster_name}.${var.domain_name}"
  count = var.instance_count

  flavor_id = data.openstack_compute_flavor_v2.masters_flavor.id
  image_id = var.base_image_id
  security_groups = var.master_sg_names
  user_data = element(
    data.ignition_config.master_ignition_config.*.rendered,
    count.index,
  )

  scheduler_hints {
    group = openstack_compute_servergroup_v2.servergroup.id
  }

  network {
    name = var.network_name
  }

  metadata = {
    role             = "master"
  }
}
