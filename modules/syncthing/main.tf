# home-server/syncthing

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.11.0"
    }
  }
  required_version = ">= 0.13"
}

data "docker_registry_image" "syncthing" {
  name = "linuxserver/syncthing:${var.syncthing_version}"
}

resource "docker_image" "syncthing" {
  name          = data.docker_registry_image.syncthing.name
  pull_triggers = [data.docker_registry_image.syncthing.sha256_digest]
}

resource "docker_volume" "syncthing_config" {
  name        = "syncthing_config"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.config_volume_mountpoint
  }
}

resource "docker_volume" "syncthing_data" {
  name        = "syncthing_data"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.data_volume_mountpoint
  }
}

resource "docker_container" "syncthing" {
  name  = "syncthing"
  image = docker_image.syncthing.latest

  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
  ]

  ports {
    internal = local.webui.port
    external = local.webui.port
    protocol = local.webui.protocol
  }
  ports {
    internal = local.listening.port
    external = local.listening.port
    protocol = local.listening.protocol
  }
  ports {
    internal = local.protocol_discovery.port
    external = local.protocol_discovery.port
    protocol = local.protocol_discovery.protocol
  }

  volumes {
    volume_name    = docker_volume.syncthing_config.name
    container_path = "/config"
  }
  volumes {
    volume_name    = docker_volume.syncthing_data.name
    container_path = "/data"
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}

locals {
  webui = {
    port     = 8384
    protocol = "tcp"
  }
  listening = {
    port     = 22000
    protocol = "tcp"
  }
  protocol_discovery = {
    port     = 21027
    protocol = "udp"
  }

  this = {
    address = docker_container.syncthing.network_data[0].ip_address
  }
}
