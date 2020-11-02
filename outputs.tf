output "lb_public_ip" {
  value = module.k8s_loadbalancer.load_balancer_ip_addresses
}

output "db_connection" {
  value     = module.k8s_database.database_connection
  sensitive = true
}

output "vm_public_ips" {
  value = module.k8s_vms.public_ips
}
