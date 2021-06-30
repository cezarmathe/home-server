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

  caddy_data_mountpoint   = local.caddy_data_mountpoint
  caddy_config_mountpoint = local.caddy_config_mountpoint

  cf_email     = local.cf_email
  cf_api_token = var.cf_api_token

  lan_cidr = local.lan_cidr
  vpn_cidr = local.vpn_cidr

  public_services = [
    {
      hostname = cloudflare_record.plex.hostname
      address  = "${module.plex.this_network_data[0].ip_address}:32400"
    },
  ]

  private_services = [
    {
      hostname = "torrents.cezarmathe.com"
      address  = "${module.transmission.this_network_data[0].ip_address}:9091"
    },
  ]
}

module "coredns" {
  source = "./modules/coredns"

  zone = data.cloudflare_zones.main.zones[0].name

  image_version = local.coredns_image_version

  addresses = local.coredns_addresses

  hostnames = [
    "torrents.cezarmathe.com",
    cloudflare_record.plex.hostname,
  ]
}

module "minecraft" {
  source  = "cezarmathe/minecraft-server/docker"
  version = "~> 0.1"

  server_properties = module.minecraft_server_properties.this
  timezone = var.timezone
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

  rcon_password  = ""
  discord_token = ""
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
  zone_id  = data.cloudflare_zones.main.zones[0].id
  name     = local.plex_cf_record_name
  value    = local.plex_cf_record_value
  type     = local.plex_cf_record_type
  proxied  = true
  ttl      = 1
}
