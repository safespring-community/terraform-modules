
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
data "ignition_filesystem" "vdb" {
  device = "/dev/vdb"
  format = "xfs"
  wipe_filesystem = true
  path = "/var/lib/containers"
}

data "ignition_systemd_unit" "var_lib_containers" {
  name = "var-lib-containers.mount"
  content = <<EOF
[Unit]
Description=Mount /var/lib/containers
Before=local-fs.target

[Mount]
What=/dev/vdb
Where=/var/lib/containers
Type=xfs

[Install]
WantedBy=local-fs.target
EOF
}

data "ignition_config" "master_ignition_config" {
  count = var.instance_count

  merge {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(var.user_data_ign)}"
  }

  files = [
    element(data.ignition_file.hostname.*.rendered, count.index)
  ]
  filesystems = [
    data.ignition_filesystem.vdb.rendered
  ]
  systemd = [
    data.ignition_systemd_unit.var_lib_containers.rendered

  ]
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

  network {
    name = var.network_name
  }

  metadata = {
    role             = "master"
  }
}

resource "gandi_livedns_record" "master_instances" {
  zone        = var.domain_name
  name        = "master-${count.index+1}-${var.cluster_name}"
  count       = var.instance_count
  ttl         = 300
  type        = "A"
  values      = [element(openstack_compute_instance_v2.master_conf.*.access_ip_v4,count.index)]
}

resource "gandi_livedns_record" "etcd_instances" {
  zone        = var.domain_name
  name        = "etcd-${count.index+1}-${var.cluster_name}"
  count       = var.instance_count
  ttl         = 300
  type        = "A"
  values      = [element(openstack_compute_instance_v2.master_conf.*.access_ip_v4,count.index)]
}

resource "gandi_livedns_record" "etcd_srv" {
  zone        = var.domain_name
  name        = "_etcd-server-ssl._tcp.${var.cluster_name}"
  ttl         = 300
  type        = "SRV"
  values      = formatlist("0 10 2380 etcd-%s-${var.cluster_name}.${var.domain_name}.",range(1,var.instance_count+1))
}
