
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  prefix = "qmsample"
}
resource "azurerm_resource_group" "rg" {
  name     = "${local.prefix}-rg"
  location = "Switzerland North"
}

resource "azurerm_storage_account" "demo_storage_account" {
  name                     = "${local.prefix}storage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_queue" "demo_storage_poison_queue" {
  name                 = "${local.prefix}-poison-queue"
  storage_account_name = azurerm_storage_account.demo_storage_account.name

}

resource "azurerm_storage_queue" "demo_storage_queue" {
  name                 = "${local.prefix}-queue"
  storage_account_name = azurerm_storage_account.demo_storage_account.name
}

locals {
  monitored_queues = [
    {
      storage_account_url = "https://${azurerm_storage_account.demo_storage_account.name}.queue.core.windows.net"
      queue_name          = azurerm_storage_queue.demo_storage_poison_queue.name
    },
    {
      storage_account_url = "https://${azurerm_storage_account.demo_storage_account.name}.queue.core.windows.net"
      queue_name          = azurerm_storage_queue.demo_storage_queue.name
    }
  ]
}
module "observability" {
  source = "./observability"

  prefix              = local.prefix
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  poison_queue_names  = [azurerm_storage_queue.demo_storage_poison_queue.name]
}

resource "azurerm_container_registry" "acr" {
  name                = "${local.prefix}acr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

module "monitor" {
  source = "./monitor"

  prefix                       = local.prefix
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  appinsight_connection_string = module.observability.appinsights_connection_string
  monitoring_queue_name        = local.monitored_queues
  registry_url                 = azurerm_container_registry.acr.login_server
  registry_username            = azurerm_container_registry.acr.admin_username
  registry_password            = azurerm_container_registry.acr.admin_password
  image_name                   = "storage-queue-monitor"
  image_tag                    = "latest"

}
