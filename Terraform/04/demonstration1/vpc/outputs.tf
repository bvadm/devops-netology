output "vpc_id" {
    description = "ID of the created VPC"
    value = yandex_vpc_network.vpc.id
}

output "subnet_id" {
    description = "ID of the created subnet"
    value = yandex_vpc_subnet.subnet.id
}