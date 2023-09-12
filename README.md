# Terraform-Managed Cluster with Docker and Nginx - Skybox Challenge 

This project demonstrates how to use Terraform to manage a cluster of Docker containers running Nginx web servers, along with a load balancer. Additionally, it includes a convenient shell script for managing the clusters operations such as installation, starting, stopping, and checking the status.

## Prerequisites
Before getting started, make sure you have the following prerequisites installed on your system:

- `Terraform`
- `Docker`

## Directory Structure

```
├── cluster_1
│   ├── configs
│   │   ├── Dockerfile_lb
│   │   ├── Dockerfile_ws
│   │   ├── entrypoint.sh
│   │   ├── nginx.lb.conf.tmpl
│   │   └── nginx.ws.conf.tmpl
│   ├── configs.tf
│   ├── main.tf
│   ├── provider.tf
│   └── variables.tf
├── cluster_2
│   ├── configs
│   │   ├── Dockerfile_lb
│   │   ├── Dockerfile_ws
│   │   ├── entrypoint.sh
│   │   ├── nginx.lb.conf.tmpl
│   │   └── nginx.ws.conf.tmpl
│   ├── configs.tf
│   ├── main.tf
│   ├── provider.tf
│   └── variables.tf
└── clusters_manager.sh
```

### Cluster 1 (`cluster_1`)

Cluster 1 contains the files and configuration specific to the first cluster:

- `configs/`: This directory contains Dockerfiles and configuration templates for Cluster 1.
  - `Dockerfile_lb`: Dockerfile for the load balancer in Cluster 1.
  - `Dockerfile_ws`: Dockerfile for the web servers in Cluster 1.
  - `entrypoint.sh`: The entrypoint script for Nginx containers in Cluster 1.
  - `nginx.lb.conf.tmpl`: Nginx configuration template for the load balancer in Cluster 1.
  - `nginx.ws.conf.tmpl`: Nginx configuration template for web servers in Cluster 1.

- `configs.tf`: Terraform configuration specific to Cluster 1 for generating Nginx configuration files.
- `main.tf`: Terraform configuration file specific to Cluster 1.
- `provider.tf`: Terraform provider configuration for Cluster 1.
- `variables.tf`: Terraform variables specific to Cluster 1.

### Cluster 2 (`cluster_2`)

Cluster 2 contains the files and configuration specific to the second cluster, similar to Cluster 1.

- `configs/`: This directory contains Dockerfiles and configuration templates for Cluster 2.
  - `Dockerfile_lb`: Dockerfile for the load balancer in Cluster 2.
  - `Dockerfile_ws`: Dockerfile for the web servers in Cluster 2.
  - `entrypoint.sh`: The entrypoint script for Nginx containers in Cluster 2.
  - `nginx.lb.conf.tmpl`: Nginx configuration template for the load balancer in Cluster 2.
  - `nginx.ws.conf.tmpl`: Nginx configuration template for web servers in Cluster 2.

- `configs.tf`: Terraform configuration specific to Cluster 2 for generating Nginx configuration files.
- `main.tf`: Terraform configuration file specific to Cluster 2.
- `provider.tf`: Terraform provider configuration for Cluster 2.
- `variables.tf`: Terraform variables specific to Cluster 2.

### Cluster Manager Script (`clusters_manager.sh`)

- `clusters_manager.sh`: The shell script for managing both Cluster 1 and Cluster 2. Use this script to perform installation, starting, stopping, and checking the status of the clusters. You can specify the cluster directory and action (e.g., install, start, stop, status) as arguments.


## Usage

To manage and deploy clusters of web servers and load balancers using Terraform and Docker, follow these steps:

### 1. Clone the Repository

  * Clone this Git repository to your local machine:

    ```shell
    git clone https://github.com/LimaHenrique/skybox-challenge.git
    
    cd skybox-challenge
    ```

### 2. Cluster Configuration

  * Create a directory for your cluster configuration, e.g., `cluster_1` or `cluster_2`. Each cluster directory should have its own set of configuration files, including Dockerfiles and Nginx templates.

### 3. Configure Variables

  * In the cluster directory, update the `variables.tf` file to customize cluster-specific variables. You can set properties such as the cluster name, the number of web servers, and their weights in load balancing.

### 4. Cluster Deployment

  * Run the clusters_manager.sh script to manage your clusters.

    ```
    ./clusters_manager.sh cluster_1 install  # Example: Install cluster_1
    ./clusters_manager.sh cluster_1 start    # Start cluster_1
    ./clusters_manager.sh cluster_1 stop     # Stop cluster_1
    ./clusters_manager.sh cluster_1 status   # Check status of cluster_1
    ```

  * Use the script with the cluster directory and a command (`install, start, stop, or status`) to manage your clusters.

### 5. Reuse or Create Additional Clusters

  * To create additional clusters, duplicate the existing cluster directory and customize its configuration as needed. For example, you can create cluster_2 based on cluster_1.

  * Update the cluster-specific variables in the variables.tf file of the new cluster directory.

### 6. Clean Up

  * To clean up resources, use the stop command for the respective clusters:
    
    ```
    ./clusters_manager.sh cluster_1 stop  # Stop cluster_1
    ./clusters_manager.sh cluster_2 stop  # Stop cluster_2 (if created)
    ```

## Testing and Code Quality

This Terraform configuration has undergone testing and code quality checks using various tools, including:

- **TFLint:** Checked for Terraform code linting and best practices.
- **TFSec:** Scanned for security-related issues.
- **Checkov:** Analyzed for misconfigurations and compliance with best practices.

These checks were performed to ensure the quality, security, and reliability of the infrastructure code.