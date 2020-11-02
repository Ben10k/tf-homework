variable "compartment_id" {
  type = string
}
variable "name" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "vm_private_ips" {
  type = list(string)
}
variable "ports" {
  type = map(string)
}

