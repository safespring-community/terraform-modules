data "openstack_compute_flavor_v2" "loadbalancer_flavor" {
  name = var.flavor_name
}

data "ignition_systemd_unit" "haproxy" {
  name    = "haproxy.service"
  content = file("${path.module}/haproxy.service")
}

data "ignition_file" "haproxy" {
  path       = "/etc/haproxy/haproxy.conf"
  mode       = "420" // 0644
  content {
    content = templatefile("${path.module}/haproxy.tmpl", {
      api           = var.api_backend_addresses,
      ingress       = var.ingress_backend_addresses
    })
  }
}

data "ignition_user" "core" {
  name                = "core"
  ssh_authorized_keys = [file(var.ssh_public_key_path)]
}

data "ignition_config" "lb" {
  users   = [data.ignition_user.core.rendered]
  files   = [data.ignition_file.haproxy.rendered]
  systemd = [data.ignition_systemd_unit.haproxy.rendered]
}

resource "openstack_compute_instance_v2" "k8s_lb" {
  name       = "lb-${var.cluster_name}.${var.domain_name}"

  flavor_id  = data.openstack_compute_flavor_v2.loadbalancer_flavor.id
  security_groups = var.loadbalancer_sg_names
  user_data = data.ignition_config.lb.rendered

  block_device {
    uuid                  = var.base_image_id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = var.lb_disk_size
    delete_on_termination = true
  }

  network {
    name = var.network_name
  }

  metadata = {
    role             = "lb"
  }
}

resource "gandi_livedns_record" "lb_instance" {
  zone        = var.domain_name
  name        = "lb-${var.cluster_name}"
  ttl         = 300
  type        = "A"
  values      = [openstack_compute_instance_v2.k8s_lb.access_ip_v4]
}

resource "gandi_livedns_record" "master_api" {
  zone        = var.domain_name
  name        = "api.${var.cluster_name}"
  ttl         = 300
  type        = "A"
  values      = [openstack_compute_instance_v2.k8s_lb.access_ip_v4]
}

resource "gandi_livedns_record" "master_api_int" {
  zone        = var.domain_name
  name        = "api-int.${var.cluster_name}"
  ttl         = 300
  type        = "A"
  values      = [openstack_compute_instance_v2.k8s_lb.access_ip_v4]
}

resource "gandi_livedns_record" "apps" {
  zone        = var.domain_name
  name        = "*.apps.${var.cluster_name}"
#  description = "apps record (DNS-RR)"
  ttl         = 300
  type        = "A"
  values      = [openstack_compute_instance_v2.k8s_lb.access_ip_v4]
}
