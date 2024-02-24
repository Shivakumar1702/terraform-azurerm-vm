resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location
}

locals {
  rgname   = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  vnetname = azurerm_virtual_network.vnet.name
  nsgname  = azurerm_network_security_group.nsgroup.name
  snetid   = azurerm_subnet.snet.id
  nsgid    = azurerm_network_security_group.nsgroup.id
  pip      = azurerm_public_ip.pip.id
  nicid    = azurerm_network_interface.nic.id
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetname
  resource_group_name = local.rgname
  location            = local.location
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "snet" {
  name                 = var.snetname
  resource_group_name  = local.rgname
  virtual_network_name = local.vnetname
  address_prefixes     = [var.address_prefixes]

}

resource "azurerm_network_security_group" "nsgroup" {
  name                = var.nsgname
  resource_group_name = local.rgname
  location            = local.location

}

resource "azurerm_network_security_rule" "nsrule" {
  name                        = "rule1"
  resource_group_name         = local.rgname
  network_security_group_name = local.nsgname
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"

}

resource "azurerm_network_security_rule" "nsrule2" {
  for_each                    = var.nsrules
  name                        = each.value.name
  resource_group_name         = local.rgname
  network_security_group_name = local.nsgname
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = "*"
  destination_address_prefix  = "*"

}

resource "azurerm_public_ip" "pip" {
  name                = var.public_ip
  resource_group_name = local.rgname
  location            = local.location
  allocation_method   = "Dynamic"

}

resource "azurerm_subnet_network_security_group_association" "snetg" {
  network_security_group_id = local.nsgid
  subnet_id                 = local.snetid

}

resource "azurerm_network_interface" "nic" {
  name                = var.nicname
  resource_group_name = local.rgname
  location            = local.location
  ip_configuration {
    name                          = "external"
    subnet_id                     = local.snetid
    public_ip_address_id          = local.pip
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vmname
  resource_group_name   = local.rgname
  location              = local.location
  size                  = var.size
  admin_username        = "adminuser"
  network_interface_ids = [local.nicid]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.pub_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}