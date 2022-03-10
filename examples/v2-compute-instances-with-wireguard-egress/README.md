## Usage

Self contained example using Safespring Terraform module together with an ansible role for wireguard gatway and clients

To install ansible role:

```
ansible-galaxy install git+https://github.com/safespring-community/ansible-role-wireguard.git
``` 

The upstream role lacked support for Ubuntu. Pull request for the upstream
role is here: https://github.com/kacperzuk/ansible-role-wireguard/pull/1 

Put your key pair in main.tf, include security group with necessary ssh and wireguard openings and:
```
terraform init
terraform apply
```

To install wireguard role: 

```
ansible-playbook -i inventory -b wg.ym
```

After this all traffic from clients should exit through the gateway.
