## tfvars
```
proxmox_endpoint = "CHANGEME"
proxmox_username = "CHANGEME"
proxmox_password = "CHANGEME"
gateway_ip       = "CHANGEME"

lxcs = {
  "syncthing" = {
    vm_id    = 100
    hostname = "container"
    ip       = "192.168.X.XX/XX"
    cpu      = 2
    memory   = 2048
    disk     = 8
  }
}
```
