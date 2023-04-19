output "vm_web_external_ip_address" {
  value       = yandex_compute_instance.web.network_interface[0].nat_ip_address
  description = "vm external ip"
}

output "vm_db_external_ip_address" {
  value       = yandex_compute_instance.db.network_interface[0].nat_ip_address
  description = "vm external ip"
}
