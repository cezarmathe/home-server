# home-server/plex - outputs

# The hostname of the Plex service.
output "service_hostname" {
  value = cloudflare_record.plex_service.name
}

# The address of the Plex service.
# Port taken from https://hub.docker.com/r/linuxserver/plex, Parameters.
output "service_address" {
  value = "${docker_container.plex.network_data[0].ip_address}:32400"
}

# Volumes for Transmission.
output "volumes" {
  value = [
    docker_volume.plex_movies.name,
    docker_volume.plex_tvseries.name,
  ]
}
