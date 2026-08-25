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
variable "vm_arr_ip" {
  type        = string
  description = "Static IP address for the Arr VM in CIDR notation"
}
variable "lxc" {
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

