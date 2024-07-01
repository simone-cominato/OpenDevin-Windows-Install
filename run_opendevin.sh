#!/usr/bin/env sh

# Use Unix line ending (so don't edit the script with notepad)
# Call the script with the following command (assuming WSL is installed)
# wsl -e ./run_opendevin.sh
# Define variables
WORKSPACE_BASE=$(pwd)/workspace;
SANDBOX_USER_ID=$(id -u)
PERSIST_SANDBOX="true"
# SSH_PASSWORD="make something up here"
SSH_PASSWORD="sshpassword"
IMAGE_NAME="ghcr.io/opendevin/opendevin:0.5"
CONTAINER_PORT=3000
HOST_PORT=3000

# Run the Docker container
docker run -it \
    --pull=missing \
    -e SANDBOX_USER_ID=$SANDBOX_USER_ID \
    -e PERSIST_SANDBOX=$PERSIST_SANDBOX \
    -e SSH_PASSWORD=$SSH_PASSWORD \
    -e WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE \
    -v $WORKSPACE_BASE:/opt/workspace_base \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -p $HOST_PORT:$CONTAINER_PORT \
    --add-host host.docker.internal:host-gateway \
    $IMAGE_NAME
