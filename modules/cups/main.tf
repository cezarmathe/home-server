# home-server/cups

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

# DNS record for the CUPS server.
resource "cloudflare_record" "cups_service" {
  zone_id  = var.cf_zone_id
  name     = var.cf_record_name
  value    = var.cf_record_value
  type     = var.cf_record_type
  proxied  = var.cf_record_proxied
  ttl      = 1
}

data "docker_registry_image" "cups" {
  name = "ydkn/cups:${var.image_version}"
}

resource "docker_image" "cups" {
  name          = data.docker_registry_image.cups.name
  pull_triggers = [data.docker_registry_image.cups.sha256_digest]
}

# CUPS config Docker volume.
resource "docker_volume" "cups_config" {
  name        = "cups_config"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.config_mountpoint
  }
}

resource "docker_container" "cups" {
  name  = "cups"
  image = docker_image.cups.latest

  volumes {
    volume_name    = docker_volume.cups_config.name
    container_path = "/etc/cups"
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}
