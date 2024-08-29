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

variable "poison_queue_names" {
  description = "Names of the poison queues"
  type        = list(string)
}
