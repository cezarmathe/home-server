# home-server

terraform {
  backend "gcs" {}
}

# Cloudflare provider
provider "cloudflare" {
  api_token = var.cf_api_token
}

# Docker provider.
provider "docker" {
  host = var.docker_host
}

data "cloudflare_zones" "main" {
  filter {
    name = var.cf_zone_name
  }
}

module "caddy" {
  source = "./modules/caddy"

  caddy_data_mountpoint   = "" # to be filled in main_override.tf
  caddy_config_mountpoint = "" # to be filled in main_override.tf

  cf_email     = var.cf_email
  cf_api_token = var.cf_api_token

  lan_cidr = "" # to be filled in main_override.tf
  vpn_cidr = "" # to be filled in main_override.tf

  public_services  = [] # to be filled in main_override.tf
  private_services = [] # to be filled in main_override.tf
}

module "coredns" {
  source = "./modules/coredns"

  zone = data.cloudflare_zones.main.zones[0].name

  image_version = "" # to be filled in main_override.tf

  addresses = [] # to be filled in main_override.tf

  hostnames = [] # to be filled in main_override.tf
}

module "minecraft" {
  source  = "cezarmathe/minecraft-server/docker"
  version = "~> 0.1"

  server_properties = module.minecraft_server_properties.this
  timezone          = var.timezone
}

module "minecraft_server_properties" {
  source  = "cezarmathe/minecraft-server-properties/null"
  version = "~> 0.1"
}

module "plex" {
  source  = "cezarmathe/plex/docker"
  version = "~> 0.1"

  plex_claim = var.plex_claim
}

module "stevebot" {
  source  = "cezarmathe/stevebot/docker"
  version = "~> 0.2"

  rcon_password = "" # to be filled in main_override.tf
  discord_token = "" # to be filled in main_override.tf
}

module "syncthing" {
  source  = "cezarmathe/syncthing/docker"
  version = "~> 0.1"

  timezone = var.timezone
}

module "transmission" {
  source  = "cezarmathe/transmission/docker"
  version = "~> 0.2"

  timezone = var.timezone
}

# DNS record for the Plex server.
resource "cloudflare_record" "plex" {
  zone_id = data.cloudflare_zones.main.zones[0].id
  name    = "" # to be filled in main_override.tf
  value   = "" # to be filled in main_override.tf
  type    = "" # to be filled in main_override.tf
  proxied = true
  ttl     = 1
}
