# home-server/plex - variables

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

variable "timezone" {
  type        = string
  description = "Timezone."
  default     = "Europe/London"
}

variable "uid" {
  type        = number
  description = "Default uid for Plex."
  default     = 1000
}

variable "gid" {
  type        = number
  description = "Default gid for Plex."
  default     = 1000
}

variable "image_version" {
  type        = string
  description = "Plex image version."
}

variable "config_mountpoint" {
  type        = string
  description = "Plex config directory mountpoint."
}

variable "movies_mountpoint" {
  type        = string
  description = "Plex movies directory mountpoint."
}

variable "tvseries_mountpoint" {
  type        = string
  description = "Plex tvseries directory mountpoint."
}

variable "plex_claim" {
  type        = string
  description = "Plex claim token."
}
