/*resource "yandex_compute_disk" "my_vol" {
  count = 3
  size = 1
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_image
}

resource "yandex_compute_instance" "web" {
  name        = "web"
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

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.my_vol
    content {
      disk_id = secondary_disk.value.id
      auto_delete = true
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat       = true
  }
    
  metadata = {
    serial-port-enable = var.options.serial_port_enable
    ssh-keys           = "${local.user}:${local.ssh_public_key}"
  }
}*/