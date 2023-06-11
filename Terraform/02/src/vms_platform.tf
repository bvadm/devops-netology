###VM vars
variable "vm_image" {
  type    = string
  default = "ubuntu-2004-lts"
}
variable "platform_id" {
  type    = string
  default = "standard-v1"
}

variable "vm_web_resources" {
  type          = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

variable "vm_db_resources" {
  type          = map(number)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}
