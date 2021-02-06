# home-server/seafile - outputs

# The hostname of the Nextcloud service.
output "service_hostname" {
  value = cloudflare_record.nextcloud.name
}

# The address of the Nextcloud service.
output "service_address" {
  value = "${docker_container.nextcloud.network_data[0].ip_address}:80"
}
