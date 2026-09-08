# Samba

## Mount Structure:** Prerequisite Check
Ensure the physical hard drives are mounted as subfolders directly inside `/srv/disks` (for example, `/srv/disks/drive1`, `/srv/disks/drive2`).

## Apply Samba Context to /srv/disks:** SELinux Configuration
Because `/srv/disks` contains external mount points, update SELinux so Samba has permission to read and write across all underlying drives:

```bash
sudo semanage fcontext -a -t samba_share_t "/srv/disks(/.*)?"
sudo restorecon -R /srv/disks
```

## Define the /srv/disks Share:** Samba Configuration
Open the Samba configuration file:

Add the following block to the /etc/samba/smb.conf to share the entire parent directory and all mounted drives inside it:

```ini
[disks]
    path = /srv/disks
    browsable = yes
    writable = yes
    read only = no
    guest ok = no
    force user = root  # Prevents permission denied errors when traversing across multiple different physical mount points

```

## Set Up Your Samba Password:** Credentials and Access
Map system user account to Samba:

```bash
sudo smbpasswd -a $USER
```

## Open Ports and Start Samba:** Firewall and Service
Configure Firewalld and activate the Samba service:

```bash
sudo firewall-cmd --permanent --add-service=samba
sudo firewall-cmd --reload
sudo systemctl enable --now smb
```
