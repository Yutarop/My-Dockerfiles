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
   --device "/dev/input/js0:/dev/input/js0" \
   --device "/dev/serial/by-id/usb-1a86_USB2.0-Ser_-if00-port0:/dev/ZLAC8015D" \
   --device "/dev/v4l/by-id/usb-046d_0821_A3461BA0-video-index0:/dev/video0" \
   --env USER=ubuntu \
   --env PASSWORD="$PASSWORD" \
   yutarop/my-ros2-desktop:humble
