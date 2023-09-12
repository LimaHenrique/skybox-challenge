# This `null_resource` is used to trigger other resources whenever it's updated.
resource "null_resource" "always_run" {
  triggers = {
    timestamp = timestamp()
  }
}

# Docker image resource for web servers.  
resource "docker_image" "webserver_nginx" {
  name = "${var.cluster_name}_webserver_nginx"

  build {
    context    = "${path.root}/configs"
    dockerfile = "Dockerfile_ws"
    tag        = ["web_server_nginx:${var.web_server_version}"]
  }

  # Define lifecycle dependency and replace_triggered_by to trigger rebuild when needed.
  lifecycle {
    replace_triggered_by = [
      null_resource.always_run
    ]
  }

  depends_on = [null_resource.custom_webserver_dockerfile]
}

# Docker image resource for the load balancer.
resource "docker_image" "load_balancer_nginx" {
  name = "${var.cluster_name}_load_balancer_nginx"

  build {
    context    = "${path.root}/configs"
    dockerfile = "Dockerfile_lb"
    tag        = ["load_balancer_nginx:${var.load_balancer_version}"]
  }

  # Define lifecycle dependency and replace_triggered_by to trigger rebuild when needed.
  lifecycle {
    replace_triggered_by = [
      null_resource.always_run
    ]
  }

  depends_on = [null_resource.custom_lb_dockerfile, null_resource.custom_lb_conf]
}

# Docker network resource for managing containers' network connectivity.
resource "docker_network" "nginx_network" {
  name = "${var.cluster_name}_nginx"
}

# Docker container resource for web servers.
resource "docker_container" "nginx_webserver" {
  count = var.web_server_count

  name = "${var.cluster_name}_web_server_${count.index + 1}"

  image = docker_image.webserver_nginx.image_id

  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://localhost/health || exit 1"]
    interval = "10s"
    timeout  = "5s"
    retries  = 3
  }

  env = [
    "MESSAGE=web-server ${count.index + 1}"
  ]

  networks_advanced {
    name = docker_network.nginx_network.id
  }

  depends_on = [docker_image.webserver_nginx]
}

# Docker container resource for the load balancer.
resource "docker_container" "nginx_lb" {
  name  = "${var.cluster_name}_nginx_lb"
  image = docker_image.load_balancer_nginx.image_id

  healthcheck {
    test     = ["CMD-SHELL", "curl -f http://localhost/health || exit 1"]
    interval = "10s"
    timeout  = "5s"
    retries  = 3
  }

  ports {
    external = var.expose_lb_port
    internal = "80"
  }

  networks_advanced {
    name = docker_network.nginx_network.id
  }

  depends_on = [docker_image.load_balancer_nginx]
}