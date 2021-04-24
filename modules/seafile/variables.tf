# home-server/seafile - variables

variable "cf_zone_id" {
  type        = string
  description = "The Zone ID where the DNS record will be created."
}

variable "cf_record_name" {
  type        = string
  description = "The name of the DNS record that will be created."
}

variable "cf_record_value" {
  type        = string
  description = "The value of the DNS record that will be created."
}

variable "cf_record_type" {
  type        = string
  description = "The DNS record type that will be created. (CNAME or A)"
}

variable "cf_record_proxied" {
  type        = bool
  description = "Whether to proxy the record through Cloudflare or not."
  default     = true
}

# Check out https://hub.docker.com/r/seafileltd/seafile-mc.
variable "seafile_image_version" {
  type        = string
  description = "The Seafile container image version."
}

# Check out https://download.seafile.com/d/320e8adf90fa43ad8fee/files/?p=/docker/docker-compose.yml.
variable "seafile_db_image_version" {
  type        = string
  description = "The Seafile database(mariadb) container image version."
}

# Check out https://download.seafile.com/d/320e8adf90fa43ad8fee/files/?p=/docker/docker-compose.yml.
variable "seafile_memcached_image_version" {
  type        = string
  description = "The Seafile memcached image version."
}

variable "seafile_data_mountpoint" {
  type        = string
  description = "Location on the host where the Seafile data volume will be created."
}

variable "seafile_config_mountpoint" {
  type        = string
  description = "Location on the host where the Seafile config volume will be created."
}

variable "seafile_logs_mountpoint" {
  type        = string
  description = "Location on the host where the Seafile logs volume will be created."
}

variable "seafile_storage_mountpoint" {
  type        = string
  description = "Location on the host where the Seafile storage volume will be created."
}

variable "seafile_db_data_mountpoint" {
  type        = string
  description = "Location on the host where the Seafile database volume will be created."
}

variable "seafile_db_root_password" {
  type        = string
  description = "Root password for the Seafile database."
}

variable "seafile_memcached_ram_mb" {
  type        = string
  description = "The amount of RAM(in MB) that memcached should use."
  default     = "256"
}

variable "seafile_admin_email" {
  type        = string
  description = "Seafile admin email."
}

variable "seafile_admin_password" {
  type        = string
  description = "Seafile admin password."
}

variable "timezone" {
  type        = string
  description = "Timezone."
  default     = "Europe/London"
}
