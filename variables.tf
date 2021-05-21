# home-server - variables

variable "docker_host" {
  type        = string
  description = "Docker host for deploying the home server."
}

variable "cf_api_token" {
  type        = string
  description = "Cloudflare API token."
}

variable "cf_zone_name" {
  type        = string
  description = "Cloudflare zone name."
}

variable "plex_claim" {
  type        = string
  description = "Plex claim."
}

variable "timezone" {
  type        = string
  description = "Timezone."
}
