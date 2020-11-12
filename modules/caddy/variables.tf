# home-server/caddy - variables

variable "docker_host" {
  type        = string
  description = "Docker host for deploying the home server."
}

variable "caddy_image_version" {
  type        = string
  description = "The caddy docker image version to use."
}

variable "caddy_data_mountpoint" {
  type        = string
  description = "Local mountpoint for the caddy data volume."
}

variable "caddy_config_mountpoint" {
  type        = string
  description = "Local mountpoint for the caddy config volume."
}

variable "public_services" {
  type = list(object({
    hostname = string
    address  = string
  }))
  description = "A list of public services that Caddy will proxy."
  default     = []
}
