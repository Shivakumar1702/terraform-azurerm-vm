variable "rgname" {
  type        = string
  default     = "resource-group-002"
  description = "Name of the resource group"

}

variable "location" {
  type        = string
  default     = "eastus"
  description = "name of the location where resources are provisioned"

}

variable "vnetname" {
  type        = string
  default     = "vnet-001"
  description = "name of the virtual network"

}

variable "address_space" {
  type        = string
  default     = "10.0.0.0/16"
  description = "IP CIDR for the virtual network"

}

variable "snetname" {
  type        = string
  default     = "snet-001"
  description = "name of the subnet"

}

variable "address_prefixes" {
  type        = string
  default     = "10.0.0.0/24"
  description = "IP CIDR prefix for the subnet"

}

variable "nsgname" {
  type        = string
  default     = "nsg-001"
  description = "name of the network security group name"

}

variable "nsrules" {
  type = map(object({
    name                   = string
    priority               = number
    direction              = string
    access                 = string
    destination_port_range = string
  }))
  default = {
    "rule2" = {
      name                   = "rule2"
      priority               = 110
      direction              = "Inbound"
      access                 = "Allow"
      destination_port_range = "8080"

    }
    "rule3" = {
      name                   = "rule3"
      priority               = 120
      direction              = "Inbound"
      access                 = "Allow"
      destination_port_range = "22"

    }
  }
  description = "rules for allowing and denying traffic to resource"

}

variable "public_ip" {
  type        = string
  default     = "public-ip-001"
  description = "name of the public ip"

}

variable "nicname" {
  type        = string
  default     = "nic-001"
  description = "name of the network interface card"

}

variable "vmname" {
  type        = string
  default     = "vm-001"
  description = "name of linux virtual machine"

}

variable "size" {
  type        = string
  default     = "Standard_B1s"
  description = "The SKU which should be used for this Virtual Machine"

}

variable "pub_key_path" {
  type        = string
  description = "path of the public key for authentication"

}