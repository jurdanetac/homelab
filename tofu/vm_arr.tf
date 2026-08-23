// *arr Debian VM
resource "proxmox_virtual_environment_vm" "vm_arr" {
  name        = "arr"
  description = "Managed by Terraform"
  tags        = ["terraform", "debian", "arr"]

  node_name = "homelab"
  vm_id     = 100

  agent {
    enabled = true
    trim    = true
    wait_for_ip {
      disabled = true
    }
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 6144
    floating  = 2048
  }

  scsi_hardware = "virtio-scsi-pci"

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_download_file.debian_13_trixie_img.id
    interface    = "scsi0"
    size         = 20
  }

  initialization {
    datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = var.vm_arr_ip
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