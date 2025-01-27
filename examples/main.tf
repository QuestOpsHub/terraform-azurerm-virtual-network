#---------------
# Random String
#---------------
module "random_string" {
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-random-string.git?ref=v1.0.0"

  length  = 4
  lower   = true
  numeric = true
  special = false
  upper   = false
}

#----------------
# Resource Group
#----------------
module "resource_group" {
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-resource-group.git?ref=v1.0.0"

  name     = "rg-${local.resource_suffix}-${module.random_string.result}"
  location = "centralus"
  tags     = merge(local.resource_tags, local.timestamp_tag)
}

#-----------------
# Virtual Network
#-----------------
module "virtual_network" {
  source = "git::https://github.com/QuestOpsHub/terraform-azurerm-virtual-network.git?ref=v1.0.0"

  name                = "vnet-${local.resource_suffix}-${module.random_string.result}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  address_space       = ["100.0.0.0/16"]
  subnets = {
    subnet1 = {
      name                            = "subnet1"
      address_prefixes                = ["100.0.1.0/24"]
      security_group                  = null
      default_outbound_access_enabled = true
      delegation                      = {}
    },
    subnet2 = {
      name                            = "subnet2"
      address_prefixes                = ["100.0.2.0/24"]
      security_group                  = null
      default_outbound_access_enabled = true
      delegation                      = {}
    }
  }
  tags = merge(local.resource_tags, local.timestamp_tag)
}