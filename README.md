# Homelab

## Diagram
```mermaid
---
title: Homelab Architecture & Infrastructure Map
---

flowchart LR
    subgraph etc ["/etc/"]
        subgraph cryptsetup_keys ["cryptsetup-keys.d/"]
            k_patriot["patriot-240.keyfile"]
            k_seagate["seagate-320.keyfile"]
            k_toshiba320["toshiba-320.keyfile"]
            k_toshiba500["toshiba-500.keyfile"]
        end

        subgraph systemd_system ["systemd/system/"]
            s_smb["smb.service"]
            s_patriot["patriot-240.service"]
            s_seagate["seagate-320.service"]
            s_toshiba320["toshiba-320.service"]
            s_toshiba500["toshiba-500.service"]
            s_mergerfs["mergerfs.service"]
        end

        subgraph samba ["samba/"]
            c_smb["smb.conf"]
        end
    end

    subgraph mnt ["/mnt/"]
        direction LR
        m_patriot["patriot-240"]
        m_seagate["seagate-320"]
        m_toshiba320["toshiba-320"]
        m_toshiba500["toshiba-500"]
        m_mergerfs["mergerfs"]
    end

    k_patriot --> s_patriot
    k_seagate --> s_seagate
    k_toshiba320 --> s_toshiba320
    k_toshiba500 --> s_toshiba500

    c_smb --> s_smb

    s_patriot --> m_patriot
    s_seagate --> m_seagate
    s_toshiba320 --> m_toshiba320
    s_toshiba500 --> m_toshiba500

    s_seagate --> s_mergerfs
    s_toshiba320 --> s_mergerfs
    s_toshiba500 --> s_mergerfs
    s_mergerfs --> m_mergerfs
```

## TODO
- Move `fstab-entries-for-SMB-mounting-of-hard-disks` entries for SMB mounting of hard disks to Ansible
- Add rationale to README
- Add Proxmox section to README
- Implement a "pre-processing" stage for the pipeline to refactor constants such as IP addresses in a file and plug them in Terraform/Ansible
- ~~Learn Ansible and add setup for the server~~


## fstab
Change the virtual permissions on SMB mounts so we can read/write.
```
# SHARED
# mergerfs  patriot-240  seagate-320  toshiba-320  toshiba-500
//192.168.0.49/mnt/mergerfs /media/mergerfs cifs guest,uid=1000,gid=1001,dir_mode=0775,file_mode=0664,iocharset=utf8,_netdev,nofail,x-systemd.automount 0 0
//192.168.0.49/mnt/patriot-240 /media/patriot-240 cifs guest,uid=1000,gid=1001,dir_mode=0775,file_mode=0664,iocharset=utf8,_netdev,nofail,x-systemd.automount 0 0
//192.168.0.49/mnt/seagate-320 /media/seagate-320 cifs guest,uid=1000,gid=1001,dir_mode=0775,file_mode=0664,iocharset=utf8,_netdev,nofail,x-systemd.automount 0 0
//192.168.0.49/mnt/toshiba-320 /media/toshiba-320 cifs guest,uid=1000,gid=1001,dir_mode=0775,file_mode=0664,iocharset=utf8,_netdev,nofail,x-systemd.automount 0 0
//192.168.0.49/mnt/toshiba-500 /media/toshiba-500 cifs guest,uid=1000,gid=1001,dir_mode=0775,file_mode=0664,iocharset=utf8,_netdev,nofail,x-systemd.automount 0 0
```

