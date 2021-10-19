output "IPv4" {
  value = openstack_compute_instance_v2.safespring_local_disk.*.access_ip_v4
}

output "IPv6" {
  value = openstack_compute_instance_v2.safespring_local_disk.*.access_ip_v6
}
