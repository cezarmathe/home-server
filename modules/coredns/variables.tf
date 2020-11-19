# home-server/coredns - variables

variable "docker_host" {
  type        = string
  description = "Docker host for deploying the home server."
}

variable "addresses" {
  type        = map(string)
  description = "Addresses that CoreDNS will serve DNS for."
}

variable "image_version" {
  type        = string
  description = "CoreDNS image version."
}

variable "zone" {
  type        = string
  description = "Zone that will be served by CoreDNS."
}

variable "hostnames" {
  type        = list(string)
  description = "Private services hostnames."
  default     = []
}
