output "ip_addresses" {
  value = [
    openstack_compute_instance_v2.master_conf.*.access_ip_v4
  ]
}
