
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

resource "azurerm_application_insights" "app_insights" {
  name                = "${local.prefix}-appinsights"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  application_type    = "web"
}

# locals {
#   monitored_queues = [
#     {
#       storage_account_url = "https://${module.orchestrator_queue_storage_account.storage_account_name}.queue.core.windows.net"
#       queue_name          = azurerm_storage_queue.orchestrator_aml_events_poison_storage_queue.name
#     },
#     {
#       storage_account_url = "https://${module.orchestrator_queue_storage_account.storage_account_name}.queue.core.windows.net"
#       queue_name          = azurerm_storage_queue.orchestrator_aml_events_storage_queue.name
#     }
#   ]
# }

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
  appinsight_connection_string = azurerm_application_insights.app_insights.connection_string
  registry_url                 = azurerm_container_registry.acr.login_server
  registry_username            = azurerm_container_registry.acr.admin_username
  registry_password            = azurerm_container_registry.acr.admin_password
  image_name                   = "storage-queue-monitor"
  image_tag                    = "latest"

}
