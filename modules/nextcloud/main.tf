# home-server/nextcloud

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.11.0"
    }
  }
  required_version = ">= 0.13"
}

# Docker provider.
provider "docker" {
  host = var.docker_host
}

# Cloudflare provider.
provider "cloudflare" {
  api_token = var.cf_api_token
}

# DNS record for the Nextcloud server.
resource "cloudflare_record" "nextcloud" {
  zone_id  = var.cf_zone_id
  name     = var.cf_record_name
  value    = var.cf_record_value
  type     = var.cf_record_type
  proxied  = var.cf_record_proxied
  ttl      = 1
}

# Nextcloud private network.
resource "docker_network" "nextcloud_private" {
  name     = "nextcloud_net_private"
  internal = true
}

# Nextcloud database Docker container.
resource "docker_container" "nextcloud_db" {
  name  = "nextcloud_db"
  image = docker_image.nextcloud_db.latest

  command = [
    "--transaction-isolation=READ-COMMITTED",
    "--binlog-format=ROW",
  ]

  env = [
    "MYSQL_ROOT_PASSWORD=${var.nextcloud_db_root_password}",
    "MYSQL_LOG_CONSOLE=true",
    "MYSQL_PASSWORD=${var.nextcloud_db_password}",
    "MYSQL_DATABASE=nextcloud",
    "MYSQL_USER=nextcloud",
  ]

  # private network
  networks_advanced {
    name = docker_network.nextcloud_private.name
  }

  # data volume
  volumes {
    volume_name    = docker_volume.nextcloud_db_data.name
    container_path = "/var/lib/mysql"
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}

# # Nextcloud memcached Docker container.
# resource "docker_container" "nextcloud_cache" {
#   name  = "nextcloud_cache"
#   image = docker_image.nextcloud_cache.latest

#   entrypoint = ["memcached", "-m", var.nextcloud_memcached_ram_mb]

#   # private network
#   networks_advanced {
#     name    = docker_network.nextcloud_private.name
#     aliases = ["memcached"] # nextcloud will look up memcached by this alias
#   }

#   must_run = true
#   restart  = "unless-stopped"
#   start    = true
# }

# Nextcloud Docker container.
resource "docker_container" "nextcloud" {
  name  = "nextcloud"
  image = docker_image.nextcloud.latest

  env = [
    "MYSQL_HOST=${docker_container.nextcloud_db.network_data[0].ip_address}",
    "MYSQL_PASSWORD=${var.nextcloud_db_password}",
    "MYSQL_DATABASE=nextcloud",
    "MYSQL_USER=nextcloud",
    # "REDIS_HOST=${docker_container.nextcloud_cache.name}",
    # "REDIS_HOST_PASSWORD="
    "TIME_ZONE=${var.timezone}",
  ]

  # private network
  networks_advanced {
    name = docker_network.nextcloud_private.name
  }

  # data volume
  volumes {
    volume_name    = docker_volume.nextcloud_data.name
    container_path = "/var/www/html"
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true

  # make sure the nextcloud container starts after memcached and mariadb
  depends_on = [
    docker_container.nextcloud_db,
    # docker_container.nextcloud_cache,
  ]
}
