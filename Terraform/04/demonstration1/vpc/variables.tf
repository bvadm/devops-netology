
variable "vpc_net_name" {
    type = string
    default = "develop"
}

variable "vpc_subnet_name" {
    default = "develop"
}

variable "ip_block" {
    default = ["10.0.1.0/24"]
}

variable "zone" {
    default = "ru-central1-a"
}
