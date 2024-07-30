#!/usr/bin/env sh
# Define variables
WORKSPACE_BASE=$(pwd)/workspace;
SANDBOX_USER_ID=$(id -u)
PERSIST_SANDBOX="true"
SSH_PASSWORD="sshpassword"
IMAGE_NAME="ghcr.io/opendevin/opendevin"
CONTAINER_PORT=3000
HOST_PORT=3000 
NAME=opendevin-app-$(date +%Y%m%d%H%M%S)
echo "$NAME\n" >> "docker_container_names.txt"
# Run the Docker container
docker run -it \
    --pull=always \
    -e SANDBOX_USER_ID=$SANDBOX_USER_ID \
    -e LLM_MODEL="openai/<your-model-name-from-lm-studio>" \
    -e LLM_BASE_URL="http://host.docker.internal:1234/v1" \
    -e CUSTOM_LLM_PROVIDER="openai" \
    -e LLM_API_KEY="lm-studio" \
    -e PERSIST_SANDBOX=$PERSIST_SANDBOX \
    -e SSH_PASSWORD=$SSH_PASSWORD \
    -e WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE \
    -v $WORKSPACE_BASE:/opt/workspace_base \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -p $HOST_PORT:$CONTAINER_PORT \
    --add-host host.docker.internal:host-gateway \
    --name $NAME \
    $IMAGE_NAME
