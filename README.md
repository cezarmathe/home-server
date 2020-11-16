# home-server

A project for hosting a few services on my server at home.

## Starter `locals.tf`

```hcl
# home-server - locals

locals {
  timezone = ""
}

# seafile variables
locals {
  cf_record_name    = ""
  cf_record_value   = ""
  cf_record_type    = ""

  seafile_image_version           = ""
  seafile_db_image_version        = ""
  seafile_memcached_image_version = ""

  seafile_data_mountpoint    = ""
  seafile_config_mountpoint  = ""
  seafile_logs_mountpoint    = ""
  seafile_storage_mountpoint = ""
  seafile_db_data_mountpoint = ""

  seafile_db_root_password = ""

  seafile_admin_email    = ""
  seafile_admin_password = ""
}

# caddy variables
locals {
  caddy_data_mountpoint   = ""
  caddy_config_mountpoint = ""

  cf_email = ""

  lan_cidr = ""
  vpn_cidr = ""
}

# minecraft variables
locals {
  minecraft_image_version = ""
  minecraft_mountpoint    = ""

  minecraft_version = ""

  minecraft_java_memory      = ""
  minecraft_container_memory = ""
  minecraft_cpu_set          = ""

  minecraft_stevebot_token = ""
}

# transmission variables
locals {
  transmission_image_version = ""

  transmission_cf_record_name  = ""
  transmission_cf_record_value = ""
  transmission_cf_record_type  = ""

  transmission_config_mountpoint            = ""
  transmission_watch_mountpoint             = ""
  transmission_downloads_default_mountpoint = ""
}
```
