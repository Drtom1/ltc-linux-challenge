## Create a Linux virtual machine

resource "azurerm_linux_virtual_machine" "ctf_vm" {
  name                = "ctf-vm"
  resource_group_name = azurerm_resource_group.ctf_rg.name
  location            = azurerm_resource_group.ctf_rg.location
  
  # Spot Instance Configuration

  priority            = "Spot"
  eviction_policy     = "Deallocate"
  max_bid_price      = -1  # Pay up to the standard VM price
  
  # VM Configuration

  size                = "Standard_DC1s_v2"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.ctf_nic.id,
  ]

  # Authentication

  admin_password                 = "CTFAdminPassword123!"
  disable_password_authentication = false

  # Disk Configuration

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # OS Image

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Custom Setup Script
  
  custom_data = base64encode(file("ctf_setup.sh"))
}