#-----------------
# Virtual Network
#-----------------
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  bgp_community       = try(var.bgp_community, null)

  dynamic "ddos_protection_plan" {
    for_each = try(var.ddos_protection_plan, {}) != {} ? [var.ddos_protection_plan] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  dynamic "encryption" {
    for_each = try(var.encryption, {}) != {} ? [var.encryption] : []
    content {
      enforcement = encryption.value.enforcement
    }
  }

  dns_servers             = try(var.dns_servers, [])
  edge_zone               = try(var.edge_zone, null)
  flow_timeout_in_minutes = try(var.flow_timeout_in_minutes, null)

  dynamic "subnet" {
    for_each = length(keys(try(var.subnet, {}))) > 0 ? try(var.subnet, {}) : {}
    content {
      name                            = subnet.value.name
      address_prefixes                = subnet.value.address_prefixes
      security_group                  = lookup(subnet.value, "security_group", null)
      default_outbound_access_enabled = lookup(subnet.value, "default_outbound_access_enabled", true)
      dynamic "delegation" {
        for_each = length(keys(lookup(subnet.value, "delegation", {}))) > 0 ? lookup(subnet.value, "delegation", {}) : {}
        content {
          name = delegation.value.name
          dynamic "service_delegation" {
            for_each = lookup(delegation.value, "service_delegation", {}) != {} ? [delegation.value.service_delegation] : []
            content {
              name    = service_delegation.value.name
              actions = lookup(service_delegation.value, "actions", [])
            }
          }
        }
      }
      private_endpoint_network_policies             = lookup(subnet.value, "private_endpoint_network_policies", "Disabled")
      private_link_service_network_policies_enabled = lookup(subnet.value, "private_link_service_network_policies_enabled", true)
      route_table_id                                = lookup(subnet.value, "route_table_id", null)
      service_endpoints                             = lookup(subnet.value, "service_endpoints", [])
      service_endpoint_policy_ids                   = lookup(subnet.value, "service_endpoint_policy_ids", [])
    }
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags["creation_timestamp"],
    ]
  }
}

#---------
# Subnets
#---------
resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = azurerm_virtual_network.virtual_network.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = length(keys(lookup(each.value, "delegation", {}))) > 0 ? lookup(each.value, "delegation", {}) : {}
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = lookup(delegation.value, "service_delegation", {}) != {} ? [delegation.value.service_delegation] : []
        content {
          name    = service_delegation.value.name
          actions = lookup(service_delegation.value, "actions", [])
        }
      }
    }
  }

  default_outbound_access_enabled               = lookup(each.value, "default_outbound_access_enabled", true)
  private_endpoint_network_policies             = lookup(each.value, "private_endpoint_network_policies", "Disabled")
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", true)
  service_endpoints                             = lookup(each.value, "service_endpoints", [])
  service_endpoint_policy_ids                   = lookup(each.value, "service_endpoint_policy_ids", [])
}