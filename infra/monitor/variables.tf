variable "prefix" {
  description = "Project prefix"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Name of the resource group"
  type        = string
}

variable "appinsight_connection_string" {
  description = "Connection string for Application Insights"
  type        = string
}
variable "monitoring_queue_name" {
  description = "Name of the queue"
  type = list(object({
    storage_account_url = string
    queue_name          = string
  }))
  default = []
}


variable "registry_url" {
  description = "URL of the container registry"
  type        = string
}

variable "registry_username" {
  description = "Username for the container registry"
  type        = string
}

variable "registry_password" {
  description = "Password for the container registry"
  type        = string
}

variable "image_name" {
  description = "Name of the container image"
  type        = string
}
variable "image_tag" {
  description = "Tag of the container image"
  type        = string
}

variable "storage_account_name_id" {
  description = "ID of the storage account"
  type        = string
  
}