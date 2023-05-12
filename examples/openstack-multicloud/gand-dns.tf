
resource "gandi_livedns_record" "rrlb" {
  zone   = "saft.in"
  name   = "www.mcdemo"
  ttl    = 300
  type   = "A"
  values = concat(tolist([for i in module.sto1_instances : i.IPv4]), openstack_networking_floatingip_v2.floatip_1.*.address)
}
