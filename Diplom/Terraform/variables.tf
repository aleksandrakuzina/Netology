# External variables

# Yandex Cloud id:
variable "yandex_cloud_id" {
  default = "_"
}

# Yandex Cloud folder id:
variable "yandex_folder_id" {
  default = "_"
}

# Public domain name:
variable "domain" {
  default = "aekuzina.site"
}

# Bool variable for LetsEncrypt staging certificate:
variable "lets_encrypt_staging" {
  default = "false"
}

# Internal variables

# Image ID Ubuntu 20.04 LTS:
variable "dist-latest" {
  default = "fd826dalmbcl81eo5nig"
}

# Image ID Ubuntu 18.04 LTS for NAT:
variable "ubuntu-nat" {
  default = "fd89681vdciaeqsurfhv"
}

# Token for working Gitlab with runner:
variable "gitlab_runner" {
  default = "o9PZATGl+oOKkyN+06jRq0usrREGzHpV7cg26xJcYBk="
}

# Internal password for replication between DB MySQL:
variable "replicator_passwd" {
  default = "R3pL!c@t0R"
}

# Passwords for access to GUI.

# Password for access to Grafana from user "admin":
variable "grafana_passwd" {
  default = "M0n1t0r1nG"
}

# Password for access to Gitlab from user "root":
variable "gitlab_passwd" {
  default = "G!tL@b-p@$$"
}
