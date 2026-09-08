# Homelab

## Software
<p align="center"><img src="images/logo.png" /></p>

## Hardware
- Processors: 4 x Intel® Core™* 15-6600 CPU @ 3.30GHz
- Memory: 8 GIB of RAM (7.6 GiB usable)
- Graphics Processor: Mesa Intel® HD Graphics 530
- Manufacturer: Dell Inc.
- Product Name: OptiPlex 5050

## Disks Diagram
```mermaid
---
title: Homelab Architecture & Infrastructure Map
---

flowchart LR
    subgraph etc ["/etc/"]
        subgraph cryptsetup_keys ["cryptsetup-keys.d/"]
            k_sandisk["sandisk-500.keyfile"]
            k_seagate["seagate-320.keyfile"]
            k_toshiba320["toshiba-320.keyfile"]
            k_toshiba500["toshiba-500.keyfile"]
        end

        subgraph systemd_system ["systemd/system/"]
            s_smb["smb.service"]
            s_sandisk["sandisk-500.service"]
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
        m_sandisk["sandisk-500"]
        m_seagate["seagate-320"]
        m_toshiba320["toshiba-320"]
        m_toshiba500["toshiba-500"]
        m_mergerfs["mergerfs"]
    end

    k_sandisk --> s_sandisk
    k_seagate --> s_seagate
    k_toshiba320 --> s_toshiba320
    k_toshiba500 --> s_toshiba500

    c_smb --> s_smb

    s_sandisk --> m_sandisk
    s_seagate --> m_seagate
    s_toshiba320 --> m_toshiba320
    s_toshiba500 --> m_toshiba500

    s_seagate --> s_mergerfs
    s_toshiba320 --> s_mergerfs
    s_toshiba500 --> s_mergerfs
    s_mergerfs --> m_mergerfs
```

## TODO
- Add rationale to README
- Use ssot
- ~~Learn Ansible and add setup for the server~~
