#resource "yandex_vpc_network" "develop" {
#  name = var.vpc_net_name
#}

#создаем подсеть
#resource "yandex_vpc_subnet" "develop" {
#  name           = var.vpc_subnet_name
#  zone           = var.zone
#  network_id     = yandex_vpc_network.develop.id
#  v4_cidr_blocks = [var.ip_block]
#}
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

locals {
  vpc_name    = "vpc-name"
  subnet_name = "subnet-name"
}

resource "yandex_vpc_network" "vpc" {
  name        = local.vpc_name
  zone        = var.zone

  timeouts {
    create = "5m"
    delete = "5m"
  }
}

resource "yandex_vpc_subnet" "subnet" {
  name                = local.subnet_name
  zone                = var.zone
  vpc_id              = yandex_vpc_network.vpc.id
  cidr_blocks         = ["10.0.0.0/24"]
  description         = "My subnet"
  private_visibility  = true
  internet_visibility = false

  timeouts {
    create = "5m"
    delete = "5m"
  }
}