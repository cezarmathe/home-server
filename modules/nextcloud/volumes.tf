# home-server/nextcloud - volumes

# Nextcloud data Docker volume.
resource "docker_volume" "nextcloud_data" {
  name        = "nextcloud_data"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.nextcloud_data_mountpoint
  }
}

# Nextcloud database Docker volume.
resource "docker_volume" "nextcloud_db_data" {
  name        = "nextcloud_db"
  driver      = "local-persist"
  driver_opts = {
    mountpoint = var.nextcloud_db_data_mountpoint
  }
}
