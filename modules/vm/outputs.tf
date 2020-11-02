output "private_ips" {
  value = oci_core_instance.k8s_vm.*.private_ip
}
output "public_ips" {
  value = oci_core_instance.k8s_vm.*.public_ip
}
