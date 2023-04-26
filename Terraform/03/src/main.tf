resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

resource "local_file" "hosts_cfg" {
  depends_on = [yandex_compute_instance.vm]
  content = templatefile("${path.module}/hosts.tftpl",

    { webservers = yandex_compute_instance.vm})

  filename = "${abspath(path.module)}/hosts.cfg"
}

resource "null_resource" "hosts_provision" {
  depends_on = [yandex_compute_instance.vm]

  provisioner "local-exec" {
    command = "cat c:/Users/bv/.ssh/ya_cl | ssh-add -"
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }

  provisioner "local-exec" {                  
    command  = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/hosts.cfg ${abspath(path.module)}/test.yml"
    on_failure = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }
    triggers = {  
      always_run         = "${timestamp()}"
      playbook_src_hash  = file("${abspath(path.module)}/test.yml")
      ssh_public_key     = local.ssh_public_key
    }
}