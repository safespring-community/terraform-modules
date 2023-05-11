output "IPv4" {
  value = openstack_compute_instance_v2.safespring_instance.access_ip_v4
}

output "IPv6" {
  value = openstack_compute_instance_v2.safespring_instance.access_ip_v6
}

output "id" {
  value = openstack_compute_instance_v2.safespring_instance.id
}
