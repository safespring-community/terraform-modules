module "my_instance" {
  source        = "github.com/safespring-community/terraform-modules/v2-compute-instance"
  name          = "demo-instance"
  key_pair_name = "your-keypair"  # Replace with your OpenStack key pair name
  image         = "ubuntu-24.04"
  flavor        = "l2.c2r4.100"   # Local disk flavor (100GB)
  network       = "default"
}

output "instance_ip" {
  value       = module.my_instance.IPv4
  description = "The IPv4 address of the instance"
}
