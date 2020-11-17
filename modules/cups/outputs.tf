# home-server/cups - outputs

# The hostname of the Plex service.
output "service_hostname" {
  value = cloudflare_record.cups_service.name
}

# The address of the CUPS service.
# Port taken from https://github.com/olbat/dockerfiles/tree/master/cupsd.
output "service_address" {
  value = "${docker_container.cups.network_data[0].ip_address}:631"
}
