resource "oci_load_balancer" "load_balancer" {
  compartment_id = var.compartment_id
  display_name   = "${var.name}LoadBalancer"
  shape          = "10Mbps-Micro"
  subnet_ids     = [var.subnet_id, ]
}

resource "oci_load_balancer_backend_set" "backend_set" {
  for_each = var.ports

  name             = "${var.name}BackendSet${each.key}"
  load_balancer_id = oci_load_balancer.load_balancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port     = each.value
    protocol = "TCP"
  }
}

locals {
  ports_on_ip = [
    for item in setproduct(keys(var.ports), var.vm_private_ips) :
    merge(
      { name = item[0] },
      { ip = item[1] },
      { port = lookup(var.ports, item[0]) }
    )
  ]
}
resource "oci_load_balancer_backend" "backend" {
  count = length(local.ports_on_ip)

  load_balancer_id = oci_load_balancer.load_balancer.id
  backendset_name  = oci_load_balancer_backend_set.backend_set[lookup(local.ports_on_ip[count.index], "name")].name
  ip_address       = lookup(local.ports_on_ip[count.index], "ip")
  port             = lookup(local.ports_on_ip[count.index], "port")
}

resource "oci_load_balancer_listener" "listener" {
  for_each = var.ports

  load_balancer_id         = oci_load_balancer.load_balancer.id
  default_backend_set_name = oci_load_balancer_backend_set.backend_set[each.key].name
  name                     = each.key
  port                     = each.value
  protocol                 = "TCP"
}
