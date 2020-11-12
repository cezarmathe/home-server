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
  cf_record_name  = local.cf_record_name
  cf_record_value = local.cf_record_value
  cf_record_type  = local.cf_record_type

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

  caddy_image_version     = local.caddy_image_version
  caddy_data_mountpoint   = local.caddy_data_mountpoint
  caddy_config_mountpoint = local.caddy_config_mountpoint

  public_services = [
    {
      hostname = module.seafile.service_hostname
      address  = module.seafile.service_address
    }
  ]
}
