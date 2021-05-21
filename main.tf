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
      hostname = cloudflare_record.transmission_service.hostname
      address  = "${module.transmission.this_network_data[0].ip_address}:9091"
    },
  ]
}

module "minecraft" {
  source = "./modules/minecraft"

  minecraft_image_version = local.minecraft_image_version
  minecraft_mountpoint    = local.minecraft_mountpoint

  minecraft_version = local.minecraft_version

  java_memory      = local.minecraft_java_memory
  container_memory = local.minecraft_container_memory
  cpu_set          = local.minecraft_cpu_set

  stevebot_token = local.minecraft_stevebot_token

  timezone = local.timezone
}

module "coredns" {
  source = "./modules/coredns"

  zone = data.cloudflare_zones.main.zones[0].name

  image_version = local.coredns_image_version

  addresses = local.coredns_addresses

  hostnames = [
    cloudflare_record.transmission_service.hostname,
    cloudflare_record.plex.hostname,
  ]
}

module "plex" {
  source  = "cezarmathe/plex/docker"
  version = "~> 0.1.2"

  plex_claim = var.plex_claim
}

module "syncthing" {
  source  = "cezarmathe/syncthing/docker"
  version = "~> 0.1.0"
}

module "transmission" {
  source  = "cezarmathe/transmission/docker"
  version = "~> 0.2"
}

# DNS record for the Transmission server.
resource "cloudflare_record" "transmission_service" {
  zone_id  = data.cloudflare_zones.main.zones[0].id
  name     = local.transmission_cf_record_name
  value    = local.transmission_cf_record_value
  type     = local.transmission_cf_record_type
  proxied  = true
  ttl      = 1
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
