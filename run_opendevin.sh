#!/usr/bin/env sh

# Use Unix line ending (so don't edit the script with notepad)
# Call the script with the following command (assuming WSL is installed)
# wsl -e ./run_opendevin.sh
# Define variables
WORKSPACE_BASE=$(pwd)/workspace;
SANDBOX_USER_ID=$(id -u)
IMAGE_NAME="ghcr.io/opendevin/opendevin:0.8"
CONTAINER_PORT=3000
HOST_PORT=3000

# Run the Docker container
docker run -it \
    --pull=missing \
    -e SANDBOX_USER_ID=$SANDBOX_USER_ID \
    -e WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE \
    -v $WORKSPACE_BASE:/opt/workspace_base \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -p $HOST_PORT:$CONTAINER_PORT \
    --add-host host.docker.internal:host-gateway \
    --name opendevin-app-$(date +%Y%m%d%H%M%S) \
    $IMAGE_NAME
