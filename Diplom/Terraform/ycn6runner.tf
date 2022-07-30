resource "yandex_compute_instance" "ycn6runner" {
  name                      = "ycn6runner"
  zone                      = "ru-central1-a"
  hostname                  = "runner.${var.domain}"
  platform_id               = "standard-v2"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 8
    core_fraction = local.instance_type[terraform.workspace]
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.dist-latest}"
      name        = "root-ycn6runner"
      type        = "network-nvme"
      size        = "20"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.priv-subnet.id}"
    ip_address = "10.10.11.15"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

