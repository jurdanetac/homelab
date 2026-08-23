terraform {
  required_providers {
    // https://search.opentofu.org/provider/bpg/proxmox/latest
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
  }
}

provider "proxmox" {
  insecure = true
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
}