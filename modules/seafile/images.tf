# home-server/seafile - images

data "docker_registry_image" "seafile" {
  name = "seafileltd/seafile-mc:${var.seafile_image_version}"
}

data "docker_registry_image" "seafile_db" {
  name = "mariadb:${var.seafile_db_image_version}"
}

data "docker_registry_image" "seafile_memcached" {
  name = "memcached:${var.seafile_memcached_image_version}"
}

# Seafile Docker image.
resource "docker_image" "seafile" {
  name          = data.docker_registry_image.seafile.name
  pull_triggers = [data.docker_registry_image.seafile.sha256_digest]
}

# Seafile database(mariadb) Docker image.
resource "docker_image" "seafile_db" {
  name          = data.docker_registry_image.seafile_db.name
  pull_triggers = [data.docker_registry_image.seafile_db.sha256_digest]
}

# Seafile memcached Docker image.
resource "docker_image" "seafile_memcached" {
  name          = data.docker_registry_image.seafile_memcached.name
  pull_triggers = [data.docker_registry_image.seafile_memcached.sha256_digest]
}
