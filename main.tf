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

  # make sure terraform will never attempt to destroy this resource
  lifecycle {
    prevent_destroy = true
  }
}

module "seafile" {
  source = "./modules/seafile"

  docker_host = var.docker_host

  cf_api_token    = var.cf_api_token
  cf_zone_id      = cloudflare_zone.main.id
  cf_record_name  = local.seafile_cf_record_name
  cf_record_value = local.seafile_cf_record_value
  cf_record_type  = local.seafile_cf_record_type

  seafile_image_version           = local.seafile_image_version
  seafile_db_image_version        = local.seafile_db_image_version
  seafile_memcached_image_version = local.seafile_memcached_image_version

  seafile_data_mountpoint    = local.seafile_data_mountpoint
  seafile_config_mountpoint  = local.seafile_config_mountpoint
  seafile_logs_mountpoint    = local.seafile_logs_mountpoint
  seafile_storage_mountpoint = local.seafile_storage_mountpoint
  seafile_db_data_mountpoint = local.seafile_db_data_mountpoint

  seafile_db_root_password = local.seafile_db_root_password

  seafile_admin_email    = local.seafile_admin_email
  seafile_admin_password = local.seafile_admin_password

  timezone = local.timezone
}

module "caddy" {
  source = "./modules/caddy"

  docker_host = var.docker_host

  caddy_data_mountpoint   = local.caddy_data_mountpoint
  caddy_config_mountpoint = local.caddy_config_mountpoint

  cf_email     = local.cf_email
  cf_api_token = var.cf_api_token

  lan_cidr = local.lan_cidr
  vpn_cidr = local.vpn_cidr

  public_services = [
    {
      hostname = module.seafile.service_hostname
      address  = module.seafile.service_address
    },
  ]

  private_services = [
    {
      hostname = module.transmission.service_hostname
      address  = module.transmission.service_address
    },
    {
      hostname = module.plex.service_hostname
      address  = module.plex.service_address
    },
    {
      hostname = module.cups.service_hostname
      address  = module.cups.service_address
    },
  ]
}

module "minecraft" {
  source = "./modules/minecraft"

  docker_host = var.docker_host

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

  docker_host = var.docker_host

  image_version = local.transmission_image_version

  cf_api_token    = var.cf_api_token
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

  docker_host = var.docker_host

  zone = cloudflare_zone.main.zone

  image_version = local.coredns_image_version

  addresses = local.coredns_addresses

  hostnames = [
    module.transmission.service_hostname,
    module.plex.service_hostname,
    module.cups.service_hostname,
  ]
}

module "plex" {
  source = "./modules/plex"

  docker_host = var.docker_host

  image_version = local.plex_image_version

  cf_api_token    = var.cf_api_token
  cf_zone_id      = cloudflare_zone.main.id
  cf_record_name  = local.plex_cf_record_name
  cf_record_value = local.plex_cf_record_value
  cf_record_type  = local.plex_cf_record_type

  config_mountpoint   = local.plex_config_mountpoint
  movies_mountpoint   = local.plex_movies_mountpoint
  tvseries_mountpoint = local.plex_tvseries_mountpoint

  plex_claim = local.plex_claim
}

module "cups" {
  source = "./modules/cups"

  docker_host = var.docker_host

  image_version = local.cups_image_version

  cf_api_token    = var.cf_api_token
  cf_zone_id      = cloudflare_zone.main.id
  cf_record_name  = local.cups_cf_record_name
  cf_record_value = local.cups_cf_record_value
  cf_record_type  = local.cups_cf_record_type

  config_mountpoint = local.cups_config_mountpoint
}
