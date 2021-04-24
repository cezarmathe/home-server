# home-server/transmission - variables

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
  description = "Default uid for torrents."
  default     = 1000
}

variable "gid" {
  type        = number
  description = "Default gid for torrents."
  default     = 1000
}

# "/combustion-release/", "/transmission-web-control/," and "/kettu/"
variable "web_home" {
  type        = string
  description = "Transmission interface."
  default     = "/combustion-release/"
}

variable "image_version" {
  type        = string
  description = "Transmission image version."
}

variable "config_mountpoint" {
  type        = string
  description = "Transmission config directory mountpoint."
}

variable "watch_mountpoint" {
  type        = string
  description = "Transmission watch directory mountpoint."
}

variable "downloads_default_mountpoint" {
  type        = string
  description = "Transmission default download directory."
}

variable "volumes" {
  type        = list(string)
  description = "A list of volume names to attach to Transmission in the downloads directory."
  default     = []
}

variable "username" {
  type        = string
  description = "Transmission webui username."
  default     = "username"
}

variable "password" {
  type        = string
  description = "Transmission webui password."
  default     = "password"
}
