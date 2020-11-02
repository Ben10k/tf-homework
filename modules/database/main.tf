resource "oci_database_autonomous_database" "database" {
  compartment_id           = var.compartment_id
  db_name                  = "${var.name}Database"
  display_name             = "${var.name}Database"
  admin_password           = var.db_password
  cpu_core_count           = "1"
  data_storage_size_in_tbs = "1"
  db_workload              = "OLTP"
  is_auto_scaling_enabled  = "false"
  license_model            = "LICENSE_INCLUDED"
  is_free_tier             = "true"
  whitelisted_ips          = [join(";", flatten([var.vcn_id, var.vm_private_ips]))]
}
