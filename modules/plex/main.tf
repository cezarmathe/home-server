# home-server/plex

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

# DNS record for the Plex server.
resource "cloudflare_record" "plex_service" {
  zone_id  = var.cf_zone_id
  name     = var.cf_record_name
  value    = var.cf_record_value
  type     = var.cf_record_type
  proxied  = var.cf_record_proxied
  ttl      = 1
}

data "docker_registry_image" "plex" {
  name = "linuxserver/plex:${var.image_version}"
}

resource "docker_image" "plex" {
  name          = data.docker_registry_image.plex.name
  pull_triggers = [data.docker_registry_image.plex.sha256_digest]
}

# Plex config Docker volume.
resource "docker_volume" "plex_config" {
  name        = "plex_config"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.config_mountpoint
  }
}

# Plex movies Docker volume.
resource "docker_volume" "plex_movies" {
  name        = "plex_movies"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.movies_mountpoint
  }
}

# Plex tvseries Docker volume.
resource "docker_volume" "plex_tvseries" {
  name        = "plex_tvseries"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.tvseries_mountpoint
  }
}

resource "docker_container" "plex" {
  name  = "plex"
  image = docker_image.plex.latest

  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "VERSION=docker",
    "UMASK_SET=022",
    "PLEX_CLAIM=${var.plex_claim}"
  ]

  devices {
    host_path      = "/dev/dri"
    container_path = "/dev/dri"
    permissions    = "rwm"
  }

  ports {
    internal = 32400
    external = 32400
    protocol = "tcp"
  }
  ports {
    internal = 1900
    external = 1900
    protocol = "udp"
  }
  ports {
    internal = 3005
    external = 3005
    protocol = "tcp"
  }
  ports {
    internal = 5353
    external = 5353
    protocol = "udp"
  }
  ports {
    internal = 8324
    external = 8324
    protocol = "tcp"
  }
  ports {
    internal = 32410
    external = 32410
    protocol = "udp"
  }
  ports {
    internal = 32412
    external = 32412
    protocol = "udp"
  }
  ports {
    internal = 32413
    external = 32413
    protocol = "udp"
  }
  ports {
    internal = 32414
    external = 32414
    protocol = "udp"
  }
  ports {
    internal = 32469
    external = 32469
    protocol = "tcp"
  }

  # config volume
  volumes {
    volume_name    = docker_volume.plex_config.name
    container_path = "/config"
  }
  # movies volume
  volumes {
    volume_name    = docker_volume.plex_movies.name
    container_path = "/movies"
  }
  # tvseries volumes
  volumes {
    volume_name    = docker_volume.plex_tvseries.name
    container_path = "/tvseries"
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}
