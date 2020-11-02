provider "oci" {
  region       = var.region
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
}

locals {
  name = "k8s"
}

resource "oci_identity_compartment" "compartment" {
  compartment_id = var.tenancy_ocid
  description    = "Created with terraform for ${local.name}"
  name           = local.name
}

module "k8s_network" {
  source                  = "./modules/network"
  name                    = local.name
  compartment_id          = oci_identity_compartment.compartment.id
  allowed_ports_in_subnet = var.ports
  allow_public_ssh        = var.allow_public_ssh
}

module "k8s_vms" {
  source                      = "./modules/vm"
  compartment_id              = oci_identity_compartment.compartment.id
  os_image_display_name       = var.os_image_display_name
  subnet_id                   = module.k8s_network.subnet_id
  allow_public_ssh            = var.allow_public_ssh
  ssh_public_key              = var.ssh_public_key
  name                        = local.name
  availability_domain_numbers = var.availability_domain_numbers
  vm_count                    = var.vm_count
  vm_shape                    = var.vm_shape
}

resource "random_password" "db_password" {
  length      = 20
  special     = false
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
}

module "k8s_database" {
  source         = "./modules/database"
  compartment_id = oci_identity_compartment.compartment.id
  name           = local.name
  db_password    = random_password.db_password.result
  vcn_id         = module.k8s_network.vcn_id
  vm_private_ips = module.k8s_vms.private_ips
}

module "k8s_loadbalancer" {
  source         = "./modules/loadbalancer"
  compartment_id = oci_identity_compartment.compartment.id
  subnet_id      = module.k8s_network.subnet_id
  vm_private_ips = module.k8s_vms.private_ips
  ports          = var.ports
  name           = local.name
}
