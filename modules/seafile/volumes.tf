# home-server/seafile - volumes

# Seafile data Docker volume.
resource "docker_volume" "seafile_data" {
  name        = "seafile_data"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.seafile_data_mountpoint
  }
}

# Seafile config Docker volume.
resource "docker_volume" "seafile_config" {
  name        = "seafile_config"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.seafile_config_mountpoint
  }
}

# Seafile logs Docker volume.
resource "docker_volume" "seafile_logs" {
  name        = "seafile_logs"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.seafile_logs_mountpoint
  }
}

# Seafile storage Docker volume.
resource "docker_volume" "seafile_storage" {
  name        = "seafile_storage"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.seafile_storage_mountpoint
  }
}

# Seafile database Docker volume.
resource "docker_volume" "seafile_db_data" {
  name        = "seafile_db"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.seafile_db_data_mountpoint
  }
}
