# home-server/transmission

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

# DNS record for the Transmission server.
resource "cloudflare_record" "transmission_service" {
  zone_id  = var.cf_zone_id
  name     = var.cf_record_name
  value    = var.cf_record_value
  type     = var.cf_record_type
  proxied  = var.cf_record_proxied
  ttl      = 1
}

data "docker_registry_image" "transmission" {
  name = "linuxserver/transmission:${var.image_version}"
}

resource "docker_image" "transmission" {
  name          = data.docker_registry_image.transmission.name
  pull_triggers = [data.docker_registry_image.transmission.sha256_digest]
}

# Transmission config Docker volume.
resource "docker_volume" "transmission_config" {
  name        = "transmission_config"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.config_mountpoint
  }
}

# Transmission watch Docker volume.
resource "docker_volume" "transmission_watch" {
  name        = "transmission_watch"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.watch_mountpoint
  }
}

# Transmission data Docker volume.
resource "docker_volume" "transmission_downloads_default" {
  name        = "transmission_downloads_default"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.downloads_default_mountpoint
  }
}

resource "docker_container" "transmission" {
  name  = "transmission"
  image = docker_image.transmission.latest

  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
    "TRANSMISSION_WEB_HOME=${var.web_home}",
  ]

  # forward torrent tcp port
  ports {
    internal = 51413
    external = 51413
    protocol = "tcp"
  }
  # forward torrent udp port
  ports {
    internal = 51413
    external = 51413
    protocol = "udp"
  }

  # config volume
  volumes {
    volume_name    = docker_volume.transmission_config.name
    container_path = "/config"
  }
  # torrents files watch volume
  volumes {
    volume_name    = docker_volume.transmission_watch.name
    container_path = "/watch"
  }
  # default download directory for torrents
  volumes {
    volume_name    = docker_volume.transmission_downloads_default.name
    container_path = "/downloads/default"
  }
  # other user-provided directories for torrents
  # these volumes must already exist
  dynamic "volumes" {
    for_each = var.volumes
    content {
      volume_name    = volume
      container_path = "/downloads/${volume}"
    }
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}
