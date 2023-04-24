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

variable "vm_resources" {
  type = list(object({
      vm_name       = string
      cpu           = number
      ram           = number
      disk          = number
      core_fraction = number
  }))
  default = [ 
    {
      cpu           = 2
      disk          = 5
      ram           = 1 
      core_fraction = 5
      vm_name       = "vm1"
    },
    {
      cpu           = 4
      disk          = 10
      ram           = 2
      core_fraction = 20
      vm_name       = "vm2"
    } 
  ]
}
