terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.111.1"
    }
  }
}

variable "endpoint" {
  type        = string
  description = "The Proxmox API endpoint URL"
}

variable "username" {
  type        = string
  description = "The Proxmox username"
}

variable "password" {
  type        = string
  description = "The Proxmox password"
  sensitive   = true
}

provider "proxmox" {
  insecure = true
  endpoint = var.endpoint
  username = var.username
  password = var.password
}

# Temporary block to test the API connection
data "proxmox_virtual_environment_vms" "test_connection" {}
