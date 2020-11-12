# home-server

A project for hosting a few services on my server at home.

# Starter `main_override.tf`

```hcl
module "seafile" {
  source = "./modules/seafile"

  docker_host = var.docker_host

  cf_api_token      = var.cloudflare_api_token
  cf_zone_id        = cloudflare_zone.main.id
  cf_record_name    = ""
  cf_record_value   = ""
  cf_record_type    = ""

  seafile_image_version           = ""
  seafile_db_image_version        = ""
  seafile_memcached_image_version = ""

  seafile_data_mountpoint    = ""
  seafile_db_data_mountpoint = ""

  seafile_db_root_password = ""

  seafile_admin_email    = ""
  seafile_admin_password = ""

  timezone = ""
}

module "caddy" {
  source = "./modules/caddy"

  docker_host = var.docker_host

  caddy_image_version     = ""
  caddy_data_mountpoint   = ""
  caddy_config_mountpoint = ""

  public_services = [
    {
      hostname = module.seafile.service_hostname
      address  = module.seafile.service_address
    }
  ]
}
```
