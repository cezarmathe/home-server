# home-server/coredns - variables

variable "docker_host" {
  type        = string
  description = "Docker host for deploying the home server."
}

variable "lan_cidr" {
  type        = string
  description = "LAN CIDR that CoreDNS will serve DNS queries for."
  default     = "192.168.0.0/24"
}

variable "lan_addr" {
  type        = string
  description = "LAN address that CoreDNS will modify DNS queries to for private services."
}

variable "vpn_cidr" {
  type        = string
  description = "VPN CIDR that CoreDNS will serve DNS queries for."
  default     = "10.0.0.0/24"
}

variable "vpn_addr" {
  type        = string
  description = "VPN address that CoreDNS will modify DNS queries to for private services."
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
