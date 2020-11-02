variable "region" {
  type        = string
  description = "Region of the resources"
  default     = "eu-frankfurt-1"
}

variable "tenancy_ocid" {
  type        = string
  description = "OCID of the root compartment"
}

variable "user_ocid" {
  type        = string
  description = "OCID of the user on who's behalf the resources are maintained"
}

variable "private_key" {
  type        = string
  description = "Private Key of the user on who's behalf the resources are maintained"
}

variable "fingerprint" {
  type        = string
  description = "Fingerprint of the Private Key of the user on who's behalf the resources are maintained"
}

variable "ssh_public_key" {
  type        = string
  description = "Public key of the private key that is used to ssh into the VMs"
}

variable "allow_public_ssh" {
  type        = bool
  description = "Should the VMs be accessible from the public internet over ssh"
  default     = false
}

variable "ports" {
  type        = map(string)
  description = "Ports which should be load-balanced and let through the firewall."
  default = {
    http     = 80,
    https    = 443,
    k8sHttps = 6443,
  }
}

variable "os_image_display_name" {
  type        = string
  description = "OS image display name from https://docs.cloud.oracle.com/en-us/iaas/images"
  default     = "Canonical-Ubuntu-18.04-Minimal-2020.10.15-0"
}
variable "vm_count" {
  type        = number
  description = "Number of VMs to provision. Maximum number for OCI free tier is 2"
  default     = 2
}

variable "vm_shape" {
  type        = string
  description = "VM shape for the provisioned VMs. Complete list at https://docs.cloud.oracle.com/Content/Compute/References/computeshapes.htm The default is the only available option in OCI free tier"
  default     = "VM.Standard.E2.1.Micro"
}

variable "availability_domain_numbers" {
  type        = list(number)
  description = "List of availability domains inside the region that should be used for VM creation. Only '3' is available in OCI free tier in 'eu-frankfurt-1' region"
  default     = [3]
}
