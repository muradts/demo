resource "azurerm_resource_group" "testrg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_group" "testnsg" {
  name                = "testnsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "testvnet" {
  name                = "testvnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "Test"
  }
}

resource "azurerm_subnet" "testsubnet" {
  name                 = "testsubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.testvnet.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on           = [azurerm_virtual_network.testvnet]
}

resource "azurerm_subnet_network_security_group_association" "testsubnetnsg" {
  subnet_id                 = azurerm_subnet.testsubnet.id
  network_security_group_id = azurerm_network_security_group.testnsg.id
}

resource "azurerm_network_interface" "testnic" {
  name                = "testnic"
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_subnet.testsubnet]

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.testsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "testvm" {
  name                  = "testvm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.testnic.id]
  vm_size               = "Standard_DS1_v2"
  depends_on            = [azurerm_network_interface.testnic]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "Test"
  }
}