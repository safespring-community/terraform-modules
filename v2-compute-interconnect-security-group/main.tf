resource "openstack_compute_secgroup_v2" "interconnect" {
  name        = "${var.name}"
  description = "${var.description}"

  rule {
    ip_protocol = "udp"
    from_port   = "1"
    to_port     = "65535"
    self        = true
  }

  rule {
    ip_protocol = "tcp"
    from_port   = "1"
    to_port     = "65535"
    self        = true
  }
}
