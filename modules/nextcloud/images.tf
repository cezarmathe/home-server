# home-server/seafile - images

data "docker_registry_image" "nextcloud_db" {
  name = "mariadb:${var.nextcloud_db_image_version}"
}

# data "docker_registry_image" "nextcloud_cache" {
#   name = "redis:${var.redis_image_version}"
# }

data "docker_registry_image" "nextcloud" {
  name = "nextcloud:${var.nextcloud_image_version}"
}

# Mariadb Docker image.
resource "docker_image" "nextcloud_db" {
  name          = data.docker_registry_image.nextcloud_db.name
  pull_triggers = [data.docker_registry_image.nextcloud_db.sha256_digest]
}

# # Redis Docker image.
# resource "docker_image" "nextcloud_cache" {
#   name          = data.docker_registry_image.nextcloud_cache.name
#   pull_triggers = [data.docker_registry_image.nextcloud_cache.sha256_digest]
# }

# Nextcloud Docker image.
resource "docker_image" "nextcloud" {
  name          = data.docker_registry_image.nextcloud.name
  pull_triggers = [data.docker_registry_image.nextcloud.sha256_digest]
}
