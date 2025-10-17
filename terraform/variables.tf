variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "nginx-webapp-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central India"
}

variable "container_name" {
  description = "Name of the container instance"
  type        = string
  default     = "nginx-webapp"
}

variable "dns_name_label" {
  description = "DNS label for the container instance"
  type        = string
  default     = "nginx-webapp-demo"
}