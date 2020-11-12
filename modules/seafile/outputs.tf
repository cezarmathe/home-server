# home-server/seafile - outputs

# The hostname of the Seafile service.
output "service_hostname" {
  value = cloudflare_record.seafile_service.name
}

# The address of the Seafile service.
output "service_address" {
  value = "${docker_container.seafile.network_data[0].ip_address}:80"
}
