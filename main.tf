# home-server

terraform {
  backend "gcs" {
    bucket = "cezarmathe-terraform-remote-state"
    prefix = "cezarmathe/home-server"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.11.0"
    }
  }

  required_version = ">= 0.13"
}

# Cloudflare provider
provider "cloudflare" {
  api_token = var.cf_api_token
}

# Docker provider.
provider "docker" {
  host = var.docker_host
}

# Main Cloudflare zone.
resource "cloudflare_zone" "main" {
  zone = var.cf_zone_name
  plan = "free"
  type = "full"

  # make sure terraform will never attempt to destroy this resource
  lifecycle {
    prevent_destroy = true
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
      hostname = module.plex.service_hostname
      address  = module.plex.service_address
    },
  ]

  private_services = [
    {
      hostname = module.transmission.service_hostname
      address  = module.transmission.service_address
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

module "transmission" {
  source = "./modules/transmission"

  image_version = local.transmission_image_version

  cf_zone_id      = cloudflare_zone.main.id
  cf_record_name  = local.transmission_cf_record_name
  cf_record_value = local.transmission_cf_record_value
  cf_record_type  = local.transmission_cf_record_type

  config_mountpoint            = local.transmission_config_mountpoint
  watch_mountpoint             = local.transmission_watch_mountpoint
  downloads_default_mountpoint = local.transmission_downloads_default_mountpoint

  volumes = module.plex.volumes
}

module "coredns" {
  source = "./modules/coredns"

  zone = cloudflare_zone.main.zone

  image_version = local.coredns_image_version

  addresses = local.coredns_addresses

  hostnames = [
    module.transmission.service_hostname,
    module.plex.service_hostname,
  ]
}

module "plex" {
  source = "./modules/plex"

  image_version = local.plex_image_version

  cf_zone_id      = cloudflare_zone.main.id
  cf_record_name  = local.plex_cf_record_name
  cf_record_value = local.plex_cf_record_value
  cf_record_type  = local.plex_cf_record_type

  config_mountpoint   = local.plex_config_mountpoint
  movies_mountpoint   = local.plex_movies_mountpoint
  tvseries_mountpoint = local.plex_tvseries_mountpoint

  plex_claim = local.plex_claim
}

module "syncthing" {
  source = "./modules/syncthing"

  config_volume_mountpoint = local.syncthing_config_volume_mountpoint
  data_volume_mountpoint   = local.syncthing_data_volume_mountpoint
  timezone                 = local.timezone
}
