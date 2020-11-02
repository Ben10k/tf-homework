terraform {
  required_version = ">= 0.13"

  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = "4.1.0"
    }
    local = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
  }
}
