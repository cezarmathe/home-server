# home-server/seafile

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
    docker = {
      source = "terraform-providers/docker"
      version = "~> 2.7.2"
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

# DNS record for the Seafile server.
resource "cloudflare_record" "seafile_service" {
  zone_id  = var.cf_zone_id
  name     = var.cf_record_name
  value    = var.cf_record_value
  type     = var.cf_record_type
  proxied  = var.cf_record_proxied
  ttl      = 1
}

# Seafile private network.
resource "docker_network" "seafile_private" {
  name     = "seafile_net_private"
  internal = true
}

# Seafile database Docker container.
resource "docker_container" "seafile_db" {
  name  = "seafile_db"
  image = docker_image.seafile_db.latest

  env = [
    "MYSQL_ROOT_PASSWORD=${var.seafile_db_root_password}",
    "MYSQL_LOG_CONSOLE=true"
  ]

  # private network
  networks_advanced {
    name = docker_network.seafile_private.name
  }

  # data volume
  volumes {
    volume_name    = docker_volume.seafile_db_data.name
    container_path = "/var/lib/mysql"
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}

# Seafile memcached Docker container.
resource "docker_container" "seafile_memcached" {
  name  = "seafile_memcached"
  image = docker_image.seafile_memcached.latest

  entrypoint = ["memcached", "-m", var.seafile_memcached_ram_mb]

  # private network
  networks_advanced {
    name    = docker_network.seafile_private.name
    aliases = ["memcached"] # seafile will look up memcached by this alias
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}

# Seafile Docker container.
resource "docker_container" "seafile" {
  name  = "seafile"
  image = docker_image.seafile.latest

  env = [
    "DB_HOST=${docker_container.seafile_db.name}",
    "DB_ROOT_PASSWD=${var.seafile_db_root_password}",
    "TIME_ZONE=${var.timezone}",
    "SEAFILE_ADMIN_EMAIL=${var.seafile_admin_email}",
    "SEAFILE_ADMIN_PASSWORD=${var.seafile_admin_password}",
    "SEAFILE_SERVER_LETSENCRYPT=false",
    "SEAFILE_SERVER_HOSTNAME=${cloudflare_record.seafile_service.name}"
  ]

  # private network
  networks_advanced {
    name = docker_network.seafile_private.name
  }

  # storage volume
  volumes {
    volume_name    = docker_volume.seafile_storage.name
    container_path = "/shared/seafile/seafile-data"
  }
  # config volume
  volumes {
    volume_name    = docker_volume.seafile_config.name
    container_path = "/shared/seafile/conf"
  }
  # logs volume
  volumes {
    volume_name    = docker_volume.seafile_logs.name
    container_path = "/shared/seafile/logs"
  }
  # data volume
  volumes {
    volume_name    = docker_volume.seafile_data.name
    container_path = "/shared"
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true

  # make sure the seafile container starts after memcached and mariadb
  depends_on = [
    docker_container.seafile_db,
    docker_container.seafile_memcached,
  ]
}
