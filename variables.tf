#-----------------
# Virtual Network
#-----------------
variable "name" {
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "address_space" {
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space."
  type        = list(string)
}

variable "bgp_community" {
  description = "(Optional) The BGP community attribute in format <as-number>:<community-value>."
  type        = string
  default     = null
}

variable "ddos_protection_plan" {
  description = "(Optional) A ddos_protection_plan block"
  type        = any
  default     = {}
}

variable "encryption" {
  description = "(Optional) A encryption block"
  type        = any
  default     = {}
}

variable "dns_servers" {
  description = "(Optional) List of IP addresses of DNS servers"
  type        = list(string)
  default     = []
}

variable "edge_zone" {
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created."
  type        = string
  default     = null
}

variable "flow_timeout_in_minutes" {
  description = " (Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes."
  type        = number
  default     = null
}

variable "subnet" {
  description = "(Optional) Can be specified multiple times to define multiple subnets. Each subnet block supports fields documented below."
  type        = any
  default     = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  type        = map(any)
  default     = {}
}

#---------
# Subnets
#---------
variable "subnets" {
  description = "One or more subnet blocks"
  default     = {}
}