# Example setting up a set of instances having wireguard addresses assigned from a CIDR based on count.index

module a_set_of_instances {
   source = "github.com/safespring-community/terraform-modules/v2-compute-instance"
   count = 3
   name          = "wg-${count.index + 1}.example.com"
   #key_pair_name = "your-keypair-name-here"
   # security_groups = ["allow-ssh-and-wireguard"]
   wg_ip         = cidrhost("192.168.45.0/24",count.index + 1)
}

