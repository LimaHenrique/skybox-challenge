#!/bin/bash

# Function to install a cluster
install_cluster() {
    local cluster_dir="$1"
    cd "$cluster_dir" || exit 1
    terraform init
    terraform apply -auto-approve
}

# Function to start a cluster
start_cluster() {
    local cluster_dir="$1"
    cd "$cluster_dir" || exit 1
    terraform apply -auto-approve
}

# Function to stop a cluster
stop_cluster() {
    local cluster_dir="$1"
    cd "$cluster_dir" || exit 1
    terraform destroy -auto-approve
}

# Function to check the status of a cluster
status_cluster() {
    local cluster_dir="$1"
    cd "$cluster_dir" || exit 1
    terraform show
}

# Main script

# Check if the script is provided with at least 2 arguments (cluster_directory and action).
if [ $# -lt 2 ]; then
    echo "Usage: $0 {cluster_directory} {install|start|stop|status}"
    exit 1
fi

cluster_dir="$1" # Store the cluster directory provided as the first argument.
command="$2" # Store the action (e.g., install, start, stop, status) provided as the second argument.

# Perform an action based on the provided command (action).
case "$command" in
    install)
        install_cluster "$cluster_dir"
        ;;
    start)
        start_cluster "$cluster_dir"
        ;;
    stop)
        stop_cluster "$cluster_dir"
        ;;
    status)
        status_cluster "$cluster_dir"
        ;;
    *)
        echo "Usage: $0 {cluster_directory} {install|start|stop|status}"
        exit 1
        ;;
esac

exit 0