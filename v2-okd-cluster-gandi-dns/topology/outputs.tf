output "loadbalancer_sg_ids" {
  value = [
    openstack_compute_secgroup_v2.lb_in.id,
    openstack_compute_secgroup_v2.k8s.id,
    openstack_networking_secgroup_v2.ssh.id,
    openstack_networking_secgroup_v2.api.id,
    openstack_networking_secgroup_v2.all_ports.id,
  ]
}

output "master_sg_ids" {
 value = [
    openstack_compute_secgroup_v2.k8s.id,
    openstack_networking_secgroup_v2.ssh.id,
    openstack_networking_secgroup_v2.all_ports.id,
  ]
}

output "worker_sg_ids" {
  value = [
    openstack_compute_secgroup_v2.k8s.id,
    openstack_networking_secgroup_v2.ssh.id,
    openstack_networking_secgroup_v2.all_ports.id,
  ]
}

output "loadbalancer_sg_names" {
  value = [
    openstack_compute_secgroup_v2.lb_in.name,
    openstack_compute_secgroup_v2.k8s.name,
    openstack_networking_secgroup_v2.ssh.name,
    openstack_networking_secgroup_v2.api.name,
    openstack_networking_secgroup_v2.all_ports.name,
  ]
}

output "master_sg_names" {
 value = [
    openstack_compute_secgroup_v2.k8s.name,
    openstack_networking_secgroup_v2.ssh.name,
    openstack_networking_secgroup_v2.all_ports.name,
  ]
}

output "worker_sg_names" {
  value = [
    openstack_compute_secgroup_v2.k8s.name,
    openstack_networking_secgroup_v2.ssh.name,
    openstack_networking_secgroup_v2.all_ports.name,
  ]
}
