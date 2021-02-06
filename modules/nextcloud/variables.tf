# home-server/nextcloud - variables

variable "docker_host" {
  type        = string
  description = "Docker host for deploying the home server."
}

variable "cf_api_token" {
  type        = string
  description = "Cloudflare API token."
}

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

variable "nextcloud_image_version" {
  type        = string
  description = "The Nextcloud container image version."
}

variable "nextcloud_db_image_version" {
  type        = string
  description = "The Nextcloud database(mariadb) container image version."
}

# variable "nextcloud_cache_image_version" {
#   type        = string
#   description = "The Nextcloud redis image version."
# }

variable "nextcloud_data_mountpoint" {
  type        = string
  description = "Location on the host where the Nextcloud data volume will be created."
}

variable "nextcloud_db_data_mountpoint" {
  type        = string
  description = "Location on the host where the Nextcloud database volume will be created."
}

variable "nextcloud_db_root_password" {
  type        = string
  description = "Root password for the Nextcloud database."
  sensitive   = true
}

variable "nextcloud_db_password" {
  type        = string
  description = "Password for the Nextcloud database."
  sensitive   = true
}

variable "timezone" {
  type        = string
  description = "Timezone."
  default     = "Europe/London"
}
