resource "azurerm_resource_group" "rg" {
  name     = "devops-task-rg"
  location = "East US"
}

resource "azurerm_resource_group" "demo" {
  name     = "rg-demo"
  location = "East US"
}

resource "azurerm_resource_group" "rg_dev" {
  name     = "rg-dev"
  location = "East US"
}

resource "azurerm_resource_group" "rg_test" {
  name     = "rg-test"
  location = "East US"
}


resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "devops-task-sa" {
  name                     = "tfstate${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "devops-task-sc" {
  name                  = "tfstate"
  storage_account_id  = azurerm_storage_account.devops-task-sa.id
  container_access_type = "private"
}

# VNet
resource "azurerm_virtual_network" "vnet_dev" {
  name                = "vnet-dev"
  location            = azurerm_resource_group.rg_dev.location
  resource_group_name = azurerm_resource_group.rg_dev.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    Environment = "Dev"
  }
}

# Subnet
resource "azurerm_subnet" "subnet_dev" {
  name                 = "subnet-dev"
  resource_group_name  = azurerm_resource_group.rg_dev.name
  virtual_network_name = azurerm_virtual_network.vnet_dev.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg_dev" {
  name                = "nsg-dev"
  location            = azurerm_resource_group.rg_dev.location
  resource_group_name = azurerm_resource_group.rg_dev.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_dev" {
  subnet_id                 = azurerm_subnet.subnet_dev.id
  network_security_group_id = azurerm_network_security_group.nsg_dev.id
}


resource "azurerm_network_interface" "nic_dev" {
  name                = "nic-dev"
  location            = azurerm_resource_group.rg_dev.location
  resource_group_name = azurerm_resource_group.rg_dev.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_dev.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.public_ip_dev.id
  }
}

resource "azurerm_public_ip" "public_ip_dev" {
  name                = "pip-dev"
  location            = azurerm_resource_group.rg_dev.location
  resource_group_name = azurerm_resource_group.rg_dev.name
  allocation_method   = "Static"   # <-- change from Dynamic to Static
  sku                 = "Standard" # explicitly set
}


resource "azurerm_linux_virtual_machine" "vm_dev" {
  name                = "vm-dev"
  location            = azurerm_resource_group.rg_dev.location
  resource_group_name = azurerm_resource_group.rg_dev.name
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_dev.id,
  ]

admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  
  admin_password = "YourStrongP@ssword123"   # for testing only (not in prod!)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  disable_password_authentication = false

  tags = {
    Environment = "Dev"
  }
}




