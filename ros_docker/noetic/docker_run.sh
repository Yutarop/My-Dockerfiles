#!/bin/bash

sudo docker run \
    --shm-size=512m \
    --net=host \
    yutarop/my-ros-desktop:noetic
