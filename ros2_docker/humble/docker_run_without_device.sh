#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: You must specify the container name as the first argument."
    echo "Usage: $0 <container_name>"
    exit 1
fi

CONTAINER_NAME=$1

read -sp "Enter password for user 'ubuntu': " PASSWORD
echo

sudo docker run \
    --name "$CONTAINER_NAME" \
    --ipc host \
    --net host \
    --shm-size=512m \
    --security-opt seccomp=unconfined \
    --env USER=ubuntu \
    --env PASSWORD="$PASSWORD" \
    tiryoh/ros2-desktop-vnc:humble
