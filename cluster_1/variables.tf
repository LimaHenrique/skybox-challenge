# Variable for specifying the directory to the Docker socket.
variable "docker_sock" {
  description = "Directory to the Docker socket"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

# Name of the cluster. Use a unique name for each cluster you create (must be the same name as the directory).
variable "cluster_name" {
  description = "Cluster Name"
  type        = string
  default     = "cluster_1"
}

# Port number exposed by the Load Balancer for incoming traffic.
variable "expose_lb_port" {
  description = "Expose Load Balancer port"
  type        = number
  default     = 81
}

# Number of web servers to run in the cluster.
variable "web_server_count" {
  description = "Number of web servers to run"
  type        = number
  default     = 3
}

# Weights for web servers in load balancing. Adjust weights to distribute traffic unevenly if needed.
variable "web_server_weights" {
  description = "Weights for web servers in load balancing"
  type        = list(number)
  default     = [3, 1, 1] # Default weights for each web server (adjust as needed)
}

# Version for the Nginx web servers.
variable "web_server_version" {
  description = "Version for web servers"
  type        = string
  default     = "1.25.2"
}

# Version for the Nginx load balancer.
variable "load_balancer_version" {
  description = "Version for the load balancer"
  type        = string
  default     = "1.25.2"
}
