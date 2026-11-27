terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "app_net" {
  name = "app-net"
}

resource "docker_image" "flask" {
  name = "flask-app:1.0"
  build {
    context = "${path.module}/app"
  }
}

resource "docker_image" "nginx" {
  name = "nginx:1.27-alpine"
}

resource "docker_container" "flask" {
  name  = "flask-app"
  image = docker_image.flask.image_id

  networks_advanced {
    name = docker_network.app_net.name
  }
  # No ports block: Flask is not reachable from the host
}

resource "docker_container" "nginx" {
  name  = "nginx-proxy"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = 8080
    ip       = "127.0.0.1"
  }

  volumes {
    host_path      = abspath("${path.module}/nginx/default.conf")
    container_path = "/etc/nginx/conf.d/default.conf"
    read_only      = true
  }

  networks_advanced {
    name = docker_network.app_net.name
  }

  depends_on = [docker_container.flask]
}
