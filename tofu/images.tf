// Debian Server cloud image
resource "proxmox_download_file" "debian_13_trixie_img" {
  content_type       = "import"
  datastore_id       = "local"
  node_name          = "homelab"
  file_name          = "debian-13-generic-amd64.qcow2"
  url                = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
  checksum           = "77429b411b39b43f914dc9d14bf34aa315489a1a12b5429f72e5b483bdda23c65698d33443c85d3f3ad7c3a0828ae60845406d6b99646342554d17abae29c2a3"
  checksum_algorithm = "sha512"
}