# home-server/syncthing - variables

variable "syncthing_version" {
  type        = string
  description = "Version of the docker container."
  default     = "latest"
}

variable "config_volume_mountpoint" {
  type        = string
  description = "Host mountpoint for the config volume."
}

variable "data_volume_mountpoint" {
  type        = string
  description = "Host mountpoint for the data volume."
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
