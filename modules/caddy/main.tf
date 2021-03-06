# home-server/caddy

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.11.0"
    }
  }
  required_version = ">= 0.13"
}

data "docker_registry_image" "caddy" {
  name = "cezarmathe/caddy:latest"
}

resource "docker_image" "caddy" {
  name          = data.docker_registry_image.caddy.name
  pull_triggers = [data.docker_registry_image.caddy.sha256_digest]
}

resource "docker_volume" "caddy_data" {
  name        = "caddy_data"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.caddy_data_mountpoint
  }
}

resource "docker_volume" "caddy_config" {
  name        = "caddy_config"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.caddy_config_mountpoint
  }
}

resource "docker_container" "caddy" {
  name  = "caddy"
  image = docker_image.caddy.latest

  env = [
    "ACME_AGREE=true",
  ]

  network_mode = "host"

  # caddy configuration file
  upload {
    file    = "/etc/caddy/Caddyfile"
    content = templatefile("${path.module}/Caddyfile", {
      cf_email     = var.cf_email
      cf_api_token = var.cf_api_token
      lan_cidr     = var.lan_cidr
      vpn_cidr     = var.vpn_cidr

      public_services  = var.public_services
      private_services = var.private_services
      blocks           = var.blocks
    })
  }

  # data volume
  volumes {
    volume_name    = docker_volume.caddy_data.name
    container_path = "/data"
  }
  # config volume
  volumes {
    volume_name    = docker_volume.caddy_config.name
    container_path = "/config"
  }

  dynamic "volumes" {
    for_each = var.html

    content {
      volume_name    = volumes.value
      container_path = "/var/www/${volumes.value}"
    }
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}
