/*
variable "lxcs" {
  type = map(object({
    vm_id         = number
    hostname      = string
    ip            = string
    start_on_boot = optional(bool, false)
    cpu           = number
    memory        = number
    disk          = number
  }))
}

resource "proxmox_virtual_environment_container" "containers" {
  for_each = var.lxcs

  node_name   = "homelab"
  vm_id       = each.value.vm_id
  description = "Managed by Terraform"
  tags        = ["terraform"]

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
      keys = [file(pathexpand(var.ssh_key_path))]
    }
  }

  network_interface {
    name   = "veth0"
    bridge = "vmbr0"
  }

  cpu {
    cores = each.value.cpu
  }

  memory {
    dedicated = each.value.memory
    swap      = each.value.memory
  }

  disk {
    datastore_id = "local-lvm"
    size         = each.value.disk
  }

  operating_system {
    template_file_id = "local:vztmpl/alpine-3.24-default_20260714_amd64.tar.xz"
    type             = "alpine"
  }
}
*/
