# home-server

A project for hosting a few services on my server at home.

# Starter `locals_overrise.tf`

```hcl
# home-server - locals

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

  timezone = ""
}

# caddy variables
locals {
  caddy_image_version     = ""
  caddy_data_mountpoint   = ""
  caddy_config_mountpoint = ""
}
```
