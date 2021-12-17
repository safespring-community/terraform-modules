output "ip_addresses" {
  value = [
    openstack_compute_instance_v2.bootstrap.*.access_ip_v4
  ]
}
