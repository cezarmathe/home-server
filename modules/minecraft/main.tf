# home-server/minecraft

terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.11.0"
    }
  }
  required_version = ">= 0.13"
}

data "docker_registry_image" "minecraft" {
  name = "itzg/minecraft-server:${var.minecraft_image_version}"
}

data "docker_registry_image" "stevebot" {
  name = "cezarmathe/stevebot:0.0.2"
}

# Minecraft Docker image.
resource "docker_image" "minecraft" {
  name          = data.docker_registry_image.minecraft.name
  pull_triggers = [data.docker_registry_image.minecraft.sha256_digest]
}

# Stevebot Docker image.
resource "docker_image" "stevebot" {
  name          = data.docker_registry_image.stevebot.name
  pull_triggers = [data.docker_registry_image.stevebot.sha256_digest]
}

# Minecraft Docker volume.
resource "docker_volume" "minecraft" {
  name        = "minecraft"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.minecraft_mountpoint
  }
}

# Minecraft Docker container.
resource "docker_container" "minecraft" {
  name  = "minecraft"
  image = docker_image.minecraft.latest

  env = [
    "MEMORY=${var.java_memory}",
    "EULA=TRUE",
    "VERSION=${var.minecraft_version}",
    "TZ=${var.timezone}"
  ]

  healthcheck {
    interval = "0s"
    retries  = 0
    start_period = "1m0s"
    test = [
      "CMD-SHELL",
      "/health.sh",
    ]
    timeout = "0s"
  }

  memory      = var.container_memory
  memory_swap = var.container_memory * 2
  cpu_set     = var.cpu_set

  # minecraft server port
  ports {
    internal = var.mc_server_port
    external = var.server_port_external
  }
  # rcon port
  ports {
    internal = var.mc_rcon_port
    external = var.rcon_port_external
    ip       = var.rcon_ip
  }

  upload {
    file    = "/data/server.properties"
    content = templatefile("${path.module}/server.properties", {
      spawn_protection                  = var.mc_spawn_protection
      max_tick_time                     = var.mc_max_tick_time
      query_port                        = var.mc_query_port
      server_name                       = var.mc_server_name
      generator_settings                = var.mc_generator_settings
      sync_chunck_writes                = var.mc_sync_chunck_writes
      force_gamemode                    = var.mc_force_gamemode
      allow_nether                      = var.mc_allow_nether
      enforce_whitelist                 = var.mc_enforce_whitelist
      gamemode                          = var.mc_gamemode
      broadcast_console_to_ops          = var.mc_broadcast_console_to_ops
      enable_query                      = var.mc_enable_query
      player_idle_timeout               = var.mc_player_idle_timeout
      difficulty                        = var.mc_difficulty
      spawn_monsters                    = var.mc_spawn_monsters
      broadcast_rcon_to_ops             = var.mc_broadcast_rcon_to_ops
      op_permission_level               = var.mc_op_permission_level
      pvp                               = var.mc_pvp
      entity_broadcast_range_percentage = var.mc_entity_broadcast_range_percentage
      snooper_enabled                   = var.mc_snooper_enabled
      level_type                        = var.mc_level_type
      rcon_ip                           = var.mc_rcon_ip
      hardcode                          = var.mc_hardcode
      enable_status                     = var.mc_enable_status
      enable_command_block              = var.mc_enable_command_block
      max_players                       = var.mc_max_players
      network_compression_threshold     = var.mc_network_compression_threshold
      resource_pack_sha1                = var.mc_resource_pack_sha1
      max_world_size                    = var.mc_max_world_size
      function_permission_level         = var.mc_function_permission_level
      rcon_port                         = var.mc_rcon_port
      server_port                       = var.mc_server_port
      debug                             = var.mc_debug
      server_ip                         = var.mc_server_ip
      spawn_npcs                        = var.mc_spawn_npcs
      allow_flight                      = var.mc_allow_flight
      level_name                        = var.mc_level_name
      view_distance                     = var.mc_view_distance
      resource_pack                     = var.mc_resource_pack
      spawn_animals                     = var.mc_spawn_animals
      white_list                        = var.mc_white_list
      rcon_password                     = var.mc_rcon_password
      generate_structures               = var.mc_generate_structures
      online_mode                       = var.mc_online_mode
      max_build_height                  = var.mc_max_build_height
      level_seed                        = var.mc_level_seed
      prevent_proxy_connections         = var.mc_prevent_proxy_connections
      use_native_transport              = var.mc_use_native_transport
      enable_jmx_monitoring             = var.mc_enable_jmx_monitoring
      rate_limit                        = var.mc_rate_limit
      enable_rcon                       = var.mc_enable_rcon
      motd                              = var.mc_motd
      text_filtering_config             = var.mc_text_filtering_config
      hardcore                          = var.mc_hardcore
    })
  }

  # storage volume
  volumes {
    volume_name    = docker_volume.minecraft.name
    container_path = "/data"
  }

  must_run = true
  restart  = "unless-stopped"
  start    = true
}

# Stevebot minecraft container
resource "docker_container" "stevebot" {
  name  = "stevebot"
  image = docker_image.stevebot.latest

  env = [
    "STEVEBOT_TOKEN=${var.stevebot_token}",
    "STEVEBOT_COMMAND_PREFIX=${var.stevebot_command_prefix}",
    "STEVEBOT_RCON_HOST=${docker_container.minecraft.network_data[0].ip_address}",
    "STEVEBOT_RCON_PORT=${var.mc_rcon_port}",
    "STEVEBOT_RCON_PASS=${var.mc_rcon_password}",
  ]

  must_run = true
  restart  = "unless-stopped"
  start    = true
}
