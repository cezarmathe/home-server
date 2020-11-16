# home-server/transmission - outputs

# The hostname of the Transmission service.
output "service_hostname" {
  value = cloudflare_record.transmission_service.name
}

# The address of the Transmission service.
# Port taken from https://hub.docker.com/r/linuxserver/transmission, Parameters.
output "service_address" {
  value = "${docker_container.transmission.network_data[0].ip_address}:9091"
}
