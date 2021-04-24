# home-server/caddy - variables

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

variable "lan_cidr" {
  type        = string
  description = "LAN CIDR that Caddy will allow to access the private services."
  default     = "192.168.0.0/24"
}

variable "vpn_cidr" {
  type        = string
  description = "VPN CIDR that Caddy will allow to access the private services."
  default     = "10.0.0.0/24"
}

variable "public_services" {
  type = list(object({
    hostname = string
    address  = string
  }))
  description = "A list of public services that Caddy will proxy."
  default     = []
}

variable "private_services" {
  type = list(object({
    hostname = string
    address  = string
  }))
  description = "A list of private services that Caddy will proxy."
  default     = []
}

variable "blocks" {
  type        = list(string)
  description = "Full blocks to include in the Caddyfile."
  default     = []
}

variable "html" {
  type        = list(string)
  description = "Html volumes to mount in /var/www/"
  default     = []
}
