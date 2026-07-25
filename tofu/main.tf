terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
  }
}


variable "ssh_key" {
  type      = string
  sensitive = true
}
variable "proxmox_endpoint" { type = string }
variable "proxmox_username" { type = string }
variable "proxmox_password" {
  type      = string
  sensitive = true
}
variable "gateway_ip" { type = string }

provider "proxmox" {
  insecure = true
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
}

variable "lxcs" {
  type = map(object({
    vm_id         = number
    hostname      = string
    ip            = string
    start_on_boot = optional(bool, false)
  }))
}

resource "proxmox_virtual_environment_container" "debian_containers" {
  for_each = var.lxcs

  node_name   = "homelab"
  vm_id       = each.value.vm_id
  description = "Managed by Terraform"
  tags        = ["terraform"]

  # These settings apply to ALL containers automatically
  unprivileged = true
  features {
    nesting = true
  }
  start_on_boot = each.value.start_on_boot

  initialization {
    hostname = each.value.hostname

    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = var.gateway_ip
      }
    }

    user_account {
      keys = [var.ssh_key]
    }
  }

  network_interface {
    name = "veth0"
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
    swap      = 2048
  }

  disk {
    datastore_id = "local-lvm"
    size         = 6
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-13-standard_13.6-1_amd64.tar.zst"
    type             = "debian"
  }
}
