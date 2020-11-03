output "subnet_id" {
  value = oci_core_subnet.subnet.id
}
output "vcn_id" {
  value = oci_core_virtual_network.vcn.id
}
output "nsg_id" {
  value = oci_core_network_security_group.network_security_group.id
}
