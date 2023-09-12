# This `null_resource` block generates a custom Dockerfile for the web servers.
resource "null_resource" "custom_webserver_dockerfile" {

  provisioner "local-exec" {
    command = <<-EOT
      cat <<EOF > configs/Dockerfile_ws
      # Pull image from docker hub
      FROM nginx:${var.web_server_version}

      # Copy the template
      COPY ./nginx.ws.conf.tmpl /nginx.conf.template

      # Copy the entrypoint
      COPY ./entrypoint.sh /entrypoint.sh

      # Set entrypoint as runnable
      RUN chmod +x /entrypoint.sh

      # Set entrypoint.sh as entrypoint command
      ENTRYPOINT ["/entrypoint.sh"]
    EOT
  }
}

# This `null_resource` block generates a custom Dockerfile for the load balancer.
resource "null_resource" "custom_lb_dockerfile" {

  provisioner "local-exec" {
    command = <<-EOT
      cat <<EOF > configs/Dockerfile_lb
      # Pull image from docker hub
      FROM nginx:${var.load_balancer_version}

      # Copy the template
      COPY ./nginx.lb.conf.tmpl /nginx.conf.template

      # Copy the entrypoint
      COPY ./entrypoint.sh /entrypoint.sh

      # Set entrypoint as runnable
      RUN chmod +x /entrypoint.sh

      # Set entrypoint.sh as entrypoint command
      ENTRYPOINT ["/entrypoint.sh"]
    EOT
  }
}

# This `null_resource` block generates the Nginx configuration template for the load balancer.
resource "null_resource" "custom_lb_conf" {
  triggers = {
    web_server_weights = join(",", var.web_server_weights) # Trigger when web server weights change.
  }

  provisioner "local-exec" {
    environment = {
      WEB_SERVER_WEIGHTS_LENGTH = length(var.web_server_weights) # Store the length of web_server_weights in an environment variable.
    }

    command = <<-EOT
      # Check if the length of web_server_weights does not match the specified web_server_count in variables.tf.
      if [ "$WEB_SERVER_WEIGHTS_LENGTH" -ne ${var.web_server_count} ]; then
        echo "Error: Number of web_server_weights does not match web_server_count in variables.tf. Please provide ${var.web_server_count} weights."
        exit 1
      fi

      cat <<EOF > configs/nginx.lb.conf.tmpl
      user  nginx;
      worker_processes  1;

      error_log  /var/log/nginx/error.log warn;
      pid        /var/run/nginx.pid;

      events {
          worker_connections  1024;
      }

      http {
          # Define an upstream block named 'myapp' for load balancing web servers.
          upstream myapp {
              ${join("\n", [for idx, weight in var.web_server_weights : "server ${var.cluster_name}_web_server_${idx + 1} weight=${weight};"])}
          }

          server {
              listen 80; # Listen on port 80 for incoming HTTP requests.

              location / {
                  proxy_pass http://myapp; # Proxy incoming requests to the 'myapp' upstream.
              }
              location /health {
                  return 200 "load-balancer"; # Return a health check response.
              }
          }
      }
    EOT
  }
}