#!/bin/bash

UID=$(id -u)
GID=$(id -g)
image_name=my-training-base
container_name=my-training-base-env
hostname=$container_name

while [[ $# -gt 0 ]]; do
    case $1 in 
    --clean-container | --clean-all)
        docker rm $container_name > /dev/null 2>&1
        ;;
    --clean-image | --clean-all)
        docker rmi $image_name > /dev/null 2>&1
        ;;
    --data-path)
        data_path=$2
    esac
    shift
done

docker build \
    --build-arg USER=$USER \
    --build-arg UID=$UID \
    --build-arg GID=$GID \
    --tag $image_name .

docker run -it \
    --gpus all \
    --volume $(dirname `pwd`):/home/$USER/workspace/my-training-base \
    --hostname $hostname \
    --name $container_name \
    -p 9092:6000 \
    $image_name
