# home-server

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
  required_version = ">= 0.13"
}

# Cloudflare provider
provider "cloudflare" {
  api_token = var.cf_api_token
}

# Main Cloudflare zone.
resource "cloudflare_zone" "main" {
  zone = var.cf_zone_name
  plan = "free"
  type = "full"
}
