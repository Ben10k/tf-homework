data "oci_identity_availability_domain" "ad" {
  count          = length(var.availability_domain_numbers)
  compartment_id = var.compartment_id
  ad_number      = var.availability_domain_numbers[count.index]
}

data "oci_core_images" "os_image" {
  compartment_id = var.compartment_id
  display_name   = var.os_image_display_name
}

resource "oci_core_instance" "k8s_vm" {
  count               = var.vm_count
  availability_domain = element(data.oci_identity_availability_domain.ad, count.index).name
  compartment_id      = var.compartment_id
  display_name        = "${var.name}Vm${count.index}"
  shape               = var.vm_shape

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "primaryVnic"
    assign_public_ip = var.allow_public_ssh
    nsg_ids          = [var.nsg_id]
    hostname_label   = "${var.name}Vm${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.os_image.images[0].id
  }
}
