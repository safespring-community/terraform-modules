# terraform-modules
General purpose terraform modules for use with the Safespring platform

Module description:

* `v2-compute-instance` for all flavors and additional disk(s). The module automatically switches to `boot-from-volume` if flavor is without local disk (and vice versa).
* `v2-compute-security-group` general security groups
* `v2-compute-interconnect-security-group` interconnect security groups

See the `examples` directory also

NB: v2 in the module directory names relates to safespring v2 platform.
