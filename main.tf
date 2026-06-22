module "networking" {
  source              = "./modules/networking"
  environment         = "dev"
  location            = "spaincentral"
  spoke_address_space = ["10.1.0.0/16"]
  subnet_prefixes = {
    frontend = "10.1.1.0/24"
    backend  = "10.1.2.0/24"
    data     = "10.1.3.0/24"
  }
  tags = {
    environment = "dev"
    project     = "az104-landing-zone"
  }
  nsg_rules = [
    {
      name                       = "allow-https-inbound"
      subnet_key                 = "frontend"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-frontend-to-backend"
      subnet_key                 = "backend"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "10.1.1.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-backend-to-data"
      subnet_key                 = "data"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "10.1.2.0/24"
      destination_address_prefix = "*"
    },
    {
      name                       = "deny-all-inbound"
      subnet_key                 = "data"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}