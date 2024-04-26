resource "openstack_compute_keypair_v2" "kp" {
  name       = replace("${var.cluster_name}-pubkey", "/[@.]/", "-")
  public_key = chomp(file(var.ssh_pubkey_path))
}

data "openstack_compute_flavor_v2" "loadbalancer_flavor" {
  name = var.flavor_name
}

resource "openstack_compute_instance_v2" "k8s_lb" {
  name       = "lb-${var.cluster_name}.${var.domain_name}"

  flavor_id  = data.openstack_compute_flavor_v2.loadbalancer_flavor.id
  security_groups = var.loadbalancer_sg_names
  key_pair   = openstack_compute_keypair_v2.kp.name

  network {
    name = var.network_name
  }

  block_device {
    uuid                  = var.image_id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = var.lb_disk_size
    delete_on_termination = true
  }

  metadata = {
    role             = "lb"
  }
}


resource "gandi_livedns_record" "lb_instance" {
  count       = var.dns_enable
  zone        = var.domain_name
  name        = "lb-${var.cluster_name}"
  ttl         = 300
  type        = "A"
  values      = [openstack_compute_instance_v2.k8s_lb.access_ip_v4]
}

resource "gandi_livedns_record" "master_api" {
  count       = var.dns_enable
  zone        = var.domain_name
  name        = "api.${var.cluster_name}"
  ttl         = 300
  type        = "A"
  values      = [openstack_compute_instance_v2.k8s_lb.access_ip_v4]
}

resource "gandi_livedns_record" "master_api_int" {
  count       = var.dns_enable
  zone        = var.domain_name
  name        = "api-int.${var.cluster_name}"
  ttl         = 300
  type        = "A"
  values      = [openstack_compute_instance_v2.k8s_lb.access_ip_v4]
}

resource "gandi_livedns_record" "apps" {
  count       = var.dns_enable
  zone        = var.domain_name
  name        = "*.apps.${var.cluster_name}"
#  description = "apps record (DNS-RR)"
  ttl         = 300
  type        = "A"
  values      = [openstack_compute_instance_v2.k8s_lb.access_ip_v4]
}
