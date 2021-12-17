data "openstack_compute_flavor_v2" "workers_flavor" {
  name = var.flavor_name
}

data "ignition_file" "hostname" {
  count = var.instance_count
  mode  = "420" // 0644
  path  = "/etc/hostname"

  content {
    content = <<EOF
worker-${count.index+1}-${var.cluster_name}.${var.domain_name}
EOF
  }
}

data "ignition_config" "worker_ignition_config" {
  count = var.instance_count

  merge {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(var.user_data_ign)}"
  }

  files = [
    element(data.ignition_file.hostname.*.rendered, count.index)
  ]
}

resource "openstack_compute_instance_v2" "k8s_worker" {
  name = "worker-${count.index+1}-${var.cluster_name}.${var.domain_name}"
  count = var.instance_count

  flavor_id = data.openstack_compute_flavor_v2.workers_flavor.id
  image_id = var.base_image_id
  security_groups = var.worker_sg_names
  user_data = element(
    data.ignition_config.worker_ignition_config.*.rendered,
    count.index,
  )

  network {
    name = var.network_name
  }

  block_device {
    uuid                  = var.base_image_id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = var.worker_disk_size
    delete_on_termination = true
  }

  metadata = {
    role             = "worker"
  }
}

resource "gandi_livedns_record" "worker_instances" {
  zone        = var.domain_name
  name        = "worker-${count.index+1}-${var.cluster_name}"
  count       = var.instance_count
  ttl         = 300
  type        = "A"
  values      = [element(openstack_compute_instance_v2.k8s_worker.*.access_ip_v4,count.index)]
}
