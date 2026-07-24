terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
  }
}


variable "endpoint" { type = string }
variable "username" { type = string }
variable "password" {
  type      = string
  sensitive = true
}

provider "proxmox" {
  insecure = true
  endpoint = var.endpoint
  username = var.username
  password = var.password
}

variable "lxcs" {
  type = map(object({
    vm_id         = number
    hostname      = string
    start_on_boot = optional(bool, false)
  }))
}

resource "proxmox_virtual_environment_container" "debian_containers" {
  for_each = var.lxcs

  node_name   = "homelab"
  vm_id       = each.value.vm_id
  description = "Managed by Terraform"

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
        address = "192.168.0.${each.value.vm_id}/24"
        gateway = "192.168.0.1"
      }
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