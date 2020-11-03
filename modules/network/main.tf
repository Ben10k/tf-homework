resource "oci_core_virtual_network" "vcn" {
  compartment_id = var.compartment_id
  display_name   = "${var.name}Vcn"
  dns_label      = "${var.name}Vcn"
  cidr_block     = "10.69.0.0/16"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  display_name   = "${var.name}InternetGateway"
  vcn_id         = oci_core_virtual_network.vcn.id
}

resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_id
  display_name   = "${var.name}RouteTable"
  vcn_id         = oci_core_virtual_network.vcn.id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_security_list" "security_list" {
  compartment_id = var.compartment_id
  display_name   = "${var.name}SecurityList"
  vcn_id         = oci_core_virtual_network.vcn.id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  dynamic "ingress_security_rules" {
    for_each = var.allow_public_ssh ? [{}] : []
    content {
      protocol    = "6"
      source      = "0.0.0.0/0"
      description = "ssh"

      tcp_options {
        max = "22"
        min = "22"
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.allowed_ports_in_subnet
    iterator = port
    content {
      protocol    = "6"
      source      = "0.0.0.0/0"
      description = port.key

      tcp_options {
        max = port.value
        min = port.value
      }
    }
  }
}

resource "oci_core_subnet" "subnet" {
  compartment_id    = var.compartment_id
  display_name      = "${var.name}Subnet"
  dns_label         = "${var.name}Subnet"
  vcn_id            = oci_core_virtual_network.vcn.id
  cidr_block        = "10.69.69.0/24"
  security_list_ids = [oci_core_security_list.security_list.id]
  route_table_id    = oci_core_route_table.route_table.id
  dhcp_options_id   = oci_core_virtual_network.vcn.default_dhcp_options_id
}

resource "oci_core_network_security_group" "network_security_group" {
  compartment_id = var.compartment_id
  display_name   = "${var.name}NetworkSecurityGroup"
  vcn_id         = oci_core_virtual_network.vcn.id
}

resource "oci_core_network_security_group_security_rule" "nsg_rule_allow_egress" {
  network_security_group_id = oci_core_network_security_group.network_security_group.id
  description               = "Allow all egress"
  protocol                  = "all"
  direction                 = "EGRESS"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}
resource "oci_core_network_security_group_security_rule" "nsg_rule_allow_ssh" {
  count = var.allow_public_ssh ? 1 : 0

  network_security_group_id = oci_core_network_security_group.network_security_group.id
  description               = "Allow ssh ingress"
  protocol                  = 6
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "nsg_rule_allow_tcp" {
  for_each = var.allowed_ports_in_subnet

  network_security_group_id = oci_core_network_security_group.network_security_group.id
  description               = "Allow ${each.key} ingress"
  protocol                  = 6
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}
