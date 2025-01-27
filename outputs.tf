#-----------------
# Virtual Network
#-----------------
output "name" {
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
  value       = azurerm_virtual_network.virtual_network.name
}

output "id" {
  description = "The virtual NetworkConfiguration ID."
  value       = azurerm_virtual_network.virtual_network.id
}

output "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the virtual network."
  value       = azurerm_virtual_network.virtual_network.resource_group_name
}

output "location" {
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
  value       = azurerm_virtual_network.virtual_network.location
}

output "address_space" {
  description = "(Required) The list of address spaces used by the virtual network."
  value       = azurerm_virtual_network.virtual_network.address_space
}

output "guid" {
  description = "The GUID of the virtual network."
  value       = azurerm_virtual_network.virtual_network.guid
}

output "subnet" {
  description = "One or more subnet blocks"
  value       = azurerm_virtual_network.virtual_network.subnet
}

#---------
# Subnets
#---------
output "subnets" {
  description = "One or more subnet blocks"
  value       = azurerm_subnet.subnet
}