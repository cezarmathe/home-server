# home-server/seafile - outputs

# The hostname of the Nextcloud service.
output "service_hostname" {
  value = cloudflare_record.nextcloud.name
}

output "service_block" {
  value = templatefile("${path.module}/Caddyfile", {
    nextcloud_container_ip = docker_container.nextcloud.network_data[0].ip_address
  })
}

output "service_volume" {
  value = docker_volume.nextcloud_data.name
}
