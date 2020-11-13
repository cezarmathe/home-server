# home-server/minecraft - variables

variable "docker_host" {
  type        = string
  description = "Docker host for deploying the home server."
}

variable "minecraft_image_version" {
  type        = string
  description = "The minecraft docker image version to use."
}

variable "minecraft_mountpoint" {
  type        = string
  description = "Local mountpoint for the minecraft volume."
}

variable "minecraft_version" {
  type        = string
  description = "Minecraft version."
  default     = "LATEST"
}

variable "timezone" {
  type        = string
  description = "Timezone."
  default     = "Europe/London"
}

variable "java_memory" {
  type        = string
  description = "The amount of memory Java should be allowed to use."
  default     = "1G"
}

variable "container_memory" {
  type        = string
  description = "The amount of memory the container should be allowed to use."
  default     = "2048"
}

variable "cpu_set" {
  type        = string
  description = "CPUs that the container is allowed to use."
  default     = "0"
}

variable "server_port_external" {
  type        = number
  description = "External minecraft server port."
  default     = 25565
}

variable "rcon_port_external" {
  type        = number
  description = "External minecraft rcon port."
  default     = 25575
}

variable "rcon_ip" {
  type        = string
  description = "Addresses allowed to access the rcon port."
  default     = "127.0.0.1"
}

# Minecraft server.properties configuration.
# Documentation and source of default values available at https://minecraft.gamepedia.com/Server.properties.

variable "mc_spawn_protection" {
  type    = number
  default = 16
}

variable "mc_max_tick_time" {
  type    = string
  default = 60000
}

variable "mc_query_port" {
  type    = number
  default = 25565
}

variable "mc_server_name" {
  type    = string
  default = "A Minecraft Server"
}

variable "mc_generator_settings" {
  type    = string
  default = ""
}

variable "mc_sync_chunck_writes" {
  type    = bool
  default = true
}

variable "mc_force_gamemode" {
  type    = bool
  default = false
}

variable "mc_allow_nether" {
  type    = bool
  default = true
}

variable "mc_enforce_whitelist" {
  type    = bool
  default = false
}

variable "mc_gamemode" {
  type    = string
  default = "survival"
}

variable "mc_broadcast_console_to_ops" {
  type    = bool
  default = true
}

variable "mc_enable_query" {
  type    = bool
  default = false
}

variable "mc_player_idle_timeout" {
  type    = number
  default = 0
}

variable "mc_difficulty" {
  type    = string
  default = "easy"
}

variable "mc_spawn_monsters" {
  type    = bool
  default = true
}

variable "mc_broadcast_rcon_to_ops" {
  type    = bool
  default = true
}

variable "mc_op_permission_level" {
  type    = number
  default = 4
}

variable "mc_pvp" {
  type    = bool
  default = true
}

variable "mc_entity_broadcast_range_percentage" {
  type    = number
  default = 100
}

variable "mc_snooper_enabled" {
  type    = bool
  default = true
}

variable "mc_level_type" {
  type    = string
  default = "default"
}

variable "mc_rcon_ip" {
  type    = string
  default = ""
}

variable "mc_hardcode" {
  type    = bool
  default = false
}

variable "mc_enable_status" {
  type    = bool
  default = true
}

variable "mc_enable_command_block" {
  type    = bool
  default = false
}

variable "mc_max_players" {
  type    = number
  default = 20
}

variable "mc_network_compression_threshold" {
  type    = number
  default = 256
}

variable "mc_resource_pack_sha1" {
  type    = string
  default = ""
}

variable "mc_max_world_size" {
  type    = number
  default = 29999984
}

variable "mc_function_permission_level" {
  type    = number
  default = 2
}

variable "mc_rcon_port" {
  type    = number
  default = 25575
}

variable "mc_server_port" {
  type    = number
  default = 25565
}

variable "mc_debug" {
  type    = bool
  default = false
}

variable "mc_server_ip" {
  type    = string
  default = ""
}

variable "mc_spawn_npcs" {
  type    = bool
  default = true
}

variable "mc_allow_flight" {
  type    = bool
  default = false
}

variable "mc_level_name" {
  type    = string
  default = "world"
}

variable "mc_view_distance" {
  type    = number
  default = 10
}

variable "mc_resource_pack" {
  type    = string
  default = ""
}

variable "mc_spawn_animals" {
  type    = bool
  default = true
}

variable "mc_white_list" {
  type    = bool
  default = false
}

variable "mc_rcon_password" {
  type    = string
  default = ""
}

variable "mc_generate_structures" {
  type    = bool
  default = true
}

variable "mc_online_mode" {
  type    = bool
  default = true
}

variable "mc_max_build_height" {
  type    = number
  default = 256
}

variable "mc_level_seed" {
  type    = string
  default = ""
}

variable "mc_prevent_proxy_connections" {
  type    = bool
  default = false
}

variable "mc_use_native_transport" {
  type    = bool
  default = true
}

variable "mc_enable_jmx_monitoring" {
  type    = bool
  default = false
}

variable "mc_rate_limit" {
  type    = number
  default = 0
}

variable "mc_enable_rcon" {
  type    = bool
  default = false
}

variable "mc_motd" {
  type    = string
  default = "A Minecraft Server"
}

variable "mc_text_filtering_config" {
  type    = string
  default = ""
}

variable "mc_hardcore" {
  type    = bool
  default = false
}
