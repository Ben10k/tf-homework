variable "compartment_id" {
  type = string
}
variable "name" {
  type = string
}
variable "db_password" {
  type = string
}
variable "vcn_id" {
  type = string
}
variable "vm_private_ips" {
  type = list(string)
}
