# home-server/coredns

terraform {
  required_providers {
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

data "docker_registry_image" "coredns" {
  name = "cezarmathe/coredns:${var.image_version}"
}

# CoreDNS Docker image.
resource "docker_image" "coredns" {
  name          = data.docker_registry_image.coredns.name
  pull_triggers = [data.docker_registry_image.coredns.sha256_digest]
}

resource "docker_container" "coredns_lan" {
  name  = "coredns_lan"
  image = docker_image.coredns.latest

  network_mode = "host"

  # coredns configuration file
  upload {
    file    = "/coredns/config/Corefile"
    content = templatefile("${path.module}/Corefile", {
      zone = var.zone
      addr = var.lan_addr
    })
  }
  # coredns hosts file
  upload {
    file    = "/etc/coredns/hosts"
    content = templatefile("${path.module}/hosts", {
      hostnames = var.hostnames
      addr      = var.lan_addr
    })
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}

resource "docker_container" "coredns_vpn" {
  name  = "coredns_vpn"
  image = docker_image.coredns.latest

  network_mode = "host"

  # coredns configuration file
  upload {
    file    = "/coredns/config/Corefile"
    content = templatefile("${path.module}/Corefile", {
      zone = var.zone
      addr = var.vpn_addr
    })
  }
  # coredns hosts file
  upload {
    file    = "/etc/coredns/hosts"
    content = templatefile("${path.module}/hosts", {
      hostnames = var.hostnames
      addr      = var.vpn_addr
    })
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}
