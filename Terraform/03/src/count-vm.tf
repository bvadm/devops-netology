data "yandex_compute_image" "ubuntu" {
  family = var.vm_image
}

resource "yandex_compute_instance" "web" {
  count       = 2
  name        = "netology-develop-platform-vm-${count.index}"
  platform_id = var.platform_id
  
  resources {
    cores          = var.vm_web_resources.cores
    memory         = var.vm_web_resources.memory
    core_fraction  = var.vm_web_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.options.serial_port_enable
    ssh-keys           = "${var.options.user}:${var.options.ssh-key}"
  }
}