variable "name" {
  type = string
}
variable "compartment_id" {
  type = string
}
variable "allowed_ports_in_subnet" {
  type = map(string)
}
variable "allow_public_ssh" {
  type = bool
}
