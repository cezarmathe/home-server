# home-server - versions.tf

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2"
    }
  }

  required_version = ">= 0.15"
}
