output "database_connection" {
  value = {
    connection_strings = oci_database_autonomous_database.database.connection_strings
    connection_urls    = oci_database_autonomous_database.database.connection_urls
    password           = var.db_password
  }
  sensitive = true
}
