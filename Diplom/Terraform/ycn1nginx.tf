resource "yandex_compute_instance" "ycn1nginx" {
  name                      = "ycn1nginx"
  zone                      = "ru-central1-b"
  hostname                  = "${var.domain}"
  platform_id               = "standard-v2"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 8
    core_fraction = local.instance_type[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.ubuntu-nat}"
      name        = "root-ycn1nginx"
      type        = "network-nvme"
      size        = "20"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.pub-subnet.id}"
    nat       = true
    ip_address = "10.10.10.10"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

