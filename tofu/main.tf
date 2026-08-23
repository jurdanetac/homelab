terraform {
  required_providers {
    // https://search.opentofu.org/provider/bpg/proxmox/latest
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
  }
}

// Proxmox login credentials
variable "proxmox_endpoint" { type = string }
variable "proxmox_username" { type = string }
variable "proxmox_password" {
  type      = string
  sensitive = true
}
variable "ssh_key_path" { // Allow SSH login to all resources using localhost key
  type      = string
  sensitive = true
  default   = "~/.ssh/id_ed25519.pub"
}
variable "gateway_ip" { type = string }

provider "proxmox" {
  insecure = true
  endpoint = var.proxmox_endpoint
  username = var.proxmox_username
  password = var.proxmox_password
}

// *arr Ubuntu VM
resource "proxmox_virtual_environment_vm" "arr_vm" {
  name        = "arr"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu", "arr"]

  node_name = "homelab"
  vm_id     = 100

  agent {
    enabled = false
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
    floating  = 2048
  }

  scsi_hardware = "virtio-scsi-pci"

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_download_file.ubuntu_26_resolute_img.id
    interface    = "scsi0"
    size         = 20
  }

  initialization {
    datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = "192.168.0.100/24"
        gateway = var.gateway_ip
      }
    }

    user_account {
      username = "arr"
      keys     = [trimspace(file(pathexpand(var.ssh_key_path)))]
    }
  }

  network_device {
    bridge = "vmbr0"
  }
}

// Ubuntu Server cloud image
resource "proxmox_download_file" "ubuntu_26_resolute_img" {
  content_type       = "import"
  datastore_id       = "local"
  node_name          = "homelab"
  file_name          = "resolute-server-cloudimg-amd64.qcow2"
  url                = "https://cloud-images.ubuntu.com/resolute/current/resolute-server-cloudimg-amd64.img"
  checksum           = "9dc7c5363c0146a08ba0c9aa834d82c2c6dfbb1c471ad9a2f0aba1189e21be05"
  checksum_algorithm = "sha256"
}

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
