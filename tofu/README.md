## tfvars
```
proxmox_endpoint = "CHANGEME"
proxmox_username = "CHANGEME"
proxmox_password = "CHANGEME"
gateway_ip       = "CHANGEME"

lxcs = {
  "hostname1" = {
    vm_id    = 100
    hostname = "container"
    ip       = "192.168.X.XX/XX"
    cpu      = 2
    memory   = 2048
    disk     = 8
  },
  "hostname2" = {
    vm_id    = 101
    hostname = "container"
    ip       = "192.168.X.XX/XX"
    cpu      = 1
    memory   = 1024
    disk     = 4
  }
}
```
