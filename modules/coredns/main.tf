# home-server/coredns

terraform {
  required_providers {
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

data "docker_registry_image" "coredns" {
  name = "cezarmathe/coredns:${var.image_version}"
}

# CoreDNS Docker image.
resource "docker_image" "coredns" {
  name          = data.docker_registry_image.coredns.name
  pull_triggers = [data.docker_registry_image.coredns.sha256_digest]
}

resource "docker_container" "coredns" {
  for_each = var.addresses

  name  = "coredns_${each.key}"
  image = docker_image.coredns.latest

  network_mode = "host"

  # coredns configuration file
  upload {
    file    = "/coredns/config/Corefile"
    content = templatefile("${path.module}/Corefile", {
      zone = var.zone
      addr = each.value
    })
  }
  # coredns hosts file
  upload {
    file    = "/etc/coredns/hosts"
    content = templatefile("${path.module}/hosts", {
      hostnames = var.hostnames
      addr      = each.value
    })
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}
