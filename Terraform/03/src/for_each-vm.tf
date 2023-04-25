/*
resource "yandex_compute_instance" "vm" {
  platform_id = var.platform_id
  for_each = {for vm in var.vm_resources: vm.vm_name => vm}
  
  name = each.value.vm_name
  resources {
    cores   = each.value.cpu
    memory  = each.value.ram
    core_fraction = each.value.core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk
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
    ssh-keys           = "${local.user}:${local.ssh_public_key}"
  }
  depends_on = [
    yandex_compute_instance.web
  ]
}
*/