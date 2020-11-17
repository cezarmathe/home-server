# home-server/cups - variables

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

variable "image_version" {
  type        = string
  description = "CUPS image version."
}

variable "config_mountpoint" {
  type        = string
  description = "CUPS config volume mountpoint."
}
