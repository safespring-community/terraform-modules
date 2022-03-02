resource "openstack_compute_secgroup_v2" "lb_in" {
  name        = "${var.cluster_name}-lb-in"
  description = "${var.cluster_name} - Load balancer ingress"

  rule {
    ip_protocol = "tcp"
    from_port   = "80"
    to_port     = "80"
    cidr        = "0.0.0.0/0"
  }
  rule {
    ip_protocol = "tcp"
    from_port   = "443"
    to_port     = "443"
    cidr        = "0.0.0.0/0"
  }
# Workaround for default network / NAT 
##  rule {
#    ip_protocol = "tcp"
#    from_port   = "22623"
#    to_port     = "22623"
#    cidr        = "185.189.29.208/28"
#  }
}

resource "openstack_compute_secgroup_v2" "k8s" {
  name        = "${var.cluster_name}-cluster"
  description = "${var.cluster_name} - Cluster access"

  rule {
    ip_protocol = "icmp"
    from_port   = "-1"
    to_port     = "-1"
    cidr        = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "tcp"
    from_port   = "1"
    to_port     = "65535"
    self        = true
  }

  rule {
    ip_protocol = "udp"
    from_port   = "1"
    to_port     = "65535"
    self        = true
  }

  rule {
    ip_protocol = "icmp"
    from_port   = "-1"
    to_port     = "-1"
    self        = true
  }
}

resource "openstack_networking_secgroup_v2" "all_ports" {
  name        = "${var.cluster_name}-all_ports"
  description = "${var.cluster_name} - all ports"
}

resource "openstack_networking_secgroup_rule_v2" "all-ports" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.all_ports.id
  count             = length(var.allow_all_ports_from_v4)
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = var.allow_all_ports_from_v4[count.index]
}

resource "openstack_networking_secgroup_v2" "api" {
  name        = "${var.cluster_name}-api"
  description = "${var.cluster_name} - api access"
}

resource "openstack_networking_secgroup_rule_v2" "api-cidr" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.api.id
  count             = length(var.allow_api_from_v4)
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = var.allow_api_from_v4[count.index]
}

resource "openstack_networking_secgroup_v2" "ssh" {
  name        = "${var.cluster_name}-ssh"
  description = "${var.cluster_name} - SSH access"
}

resource "openstack_networking_secgroup_rule_v2" "ssh-cidr" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.ssh.id
  count             = length(var.allow_ssh_from_v4)
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.allow_ssh_from_v4[count.index]
}
