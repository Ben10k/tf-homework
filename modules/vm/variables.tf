variable "compartment_id" {
  type = string
}
variable "os_image_display_name" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "allow_public_ssh" {
  type = bool
}
variable "ssh_public_key" {
  type = string
}
variable "name" {
  type = string
}
variable "availability_domain_numbers" {
  type = list(number)
}
variable "vm_shape" {
  type = string
}
variable "vm_count" {
  type = number
}
