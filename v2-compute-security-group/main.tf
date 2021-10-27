resource "openstack_compute_secgroup_v2" "sf_sg" {
  name        = "${var.name}"
  description = "${var.description}"

  dynamic "rule" {
    for_each = var.rules
    content {
      ip_protocol = rule.value["ip_protocol"]
      from_port   = rule.value["from_port"]
      to_port     = rule.value["to_port"]
      cidr        = rule.value["cidr"]
    }
  }
}
