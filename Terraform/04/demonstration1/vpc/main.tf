resource "yandex_vpc_network" "develop" {
  name = var.vpc_net_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_subnet_name
  zone           = var.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = [var.ip_block]
}   