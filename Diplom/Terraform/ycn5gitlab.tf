resource "yandex_compute_instance" "ycn5gitlab" {
  name                      = "ycn5gitlab"
  zone                      = "ru-central1-a"
  hostname                  = "gitlab.${var.domain}"
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
      name        = "root-ycn5gitlab"
      type        = "network-nvme"
      size        = "20"
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.priv-subnet.id}"
    ip_address = "10.10.11.14"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

