# home-server/caddy - variables

variable "docker_host" {
  type        = string
  description = "Docker host for deploying the home server."
}

variable "caddy_data_mountpoint" {
  type        = string
  description = "Local mountpoint for the caddy data volume."
}

variable "caddy_config_mountpoint" {
  type        = string
  description = "Local mountpoint for the caddy config volume."
}

variable "cf_email" {
  type        = string
  description = "Cloudflare email(used for the DNS challenge)."
}

variable "cf_api_token" {
  type        = string
  description = "Cloudflare API token(used for the DNS challenge)."
}

variable "public_services" {
  type = list(object({
    hostname = string
    address  = string
  }))
  description = "A list of public services that Caddy will proxy."
  default     = []
}
