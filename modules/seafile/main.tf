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

locals {
  seafile_public_port = 8000
}

# DNS record for the Seafile server.
resource "cloudflare_record" "seafile_service" {
  zone_id  = var.cf_zone_id
  name     = var.cf_record_name # "files.cezarmathe.com"
  value    = var.cf_record_value # "dorm.cezarmathe.com"
  type     = var.cf_record_type # "CNAME"
  proxied  = var.cf_record_proxied
  ttl      = 1
}

data "docker_registry_image" "seafile" {
  name = "seafileltd/seafile-mc:${var.seafile_image_version}"
}

data "docker_registry_image" "seafile_db" {
  name = "mariadb:${var.seafile_db_image_version}"
}

data "docker_registry_image" "seafile_memcached" {
  name = "memcached:${var.seafile_memcached_image_version}"
}

# Seafile Docker image.
resource "docker_image" "seafile" {
  name          = data.docker_registry_image.seafile.name
  pull_triggers = [data.docker_registry_image.seafile.sha256_digest]
}

# Seafile database(mariadb) Docker image.
resource "docker_image" "seafile_db" {
  name          = data.docker_registry_image.seafile_db.name
  pull_triggers = [data.docker_registry_image.seafile_db.sha256_digest]
}

# Seafile memcached Docker image.
resource "docker_image" "seafile_memcached" {
  name          = data.docker_registry_image.seafile_memcached.name
  pull_triggers = [data.docker_registry_image.seafile_memcached.sha256_digest]
}

# Seafile private network.
resource "docker_network" "seafile_private" {
  name     = "seafile_net_private"
  internal = true
}

# Seafile public network.
resource "docker_network" "seafile_public" {
  name = "seafile_net_public"
}

# Seafile Docker volume.
resource "docker_volume" "seafile_data" {
  name        = "seafile_data"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.seafile_data_mountpoint
  }
}

# Seafile database Docker volume.
resource "docker_volume" "seafile_db_data" {
  name        = "seafile_db"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.seafile_db_data_mountpoint
  }
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
    name = docker_network.seafile_private.name
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}

# Seafile Docker container.
resource "docker_container" "seafile" {
  depends_on = [
    docker_container.seafile_db,
    docker_container.seafile_memcached
  ]

  name  = "seafile"
  image = docker_image.seafile.latest

  env = [
    "DB_HOST=${docker_container.seafile_db.network_data[0].ip_address}",
    "DB_ROOT_PASSWD=${var.seafile_db_root_password}",
    "TIME_ZONE=${var.timezone}",
    "SEAFILE_ADMIN_EMAIL=${var.seafile_admin_email}",
    "SEAFILE_ADMIN_PASSWORD=${var.seafile_admin_password}",
    "SEAFILE_SERVER_LETSENCRYPT=false",
    "SEAFILE_SERVER_HOSTNAME=${cloudflare_record.seafile_service.name}"
  ]

  # public network
  networks_advanced {
    name = docker_network.seafile_public.name
  }
  # private network
  networks_advanced {
    name = docker_network.seafile_private.name
  }

  # http port, available only for localhost(will be proxied by caddy)
  ports {
    internal = 80
    external = local.seafile_public_port
    ip       = "127.0.0.1"
  }

  # data volume
  volumes {
    volume_name    = docker_volume.seafile_data.name
    container_path = "/shared"
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}

