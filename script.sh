#!/bin/bash

echo "Hello, This is my final project for Dhub!"

#Env
DOCKER_REGISTRY='aliamin10'
IMAGE_NAME='webweather'
CONTAINER_NAME='weather-app'
DOCKER_PORT='5000'

#Stages

echo "===== First Stage: Build Image ====="
docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest .
if [ $? -eq 0 ]; then
    echo "Image built successfully."
else
    echo "Failed to build image."
    exit 1
fi

echo "===== Second Stage: Run Container ====="
docker rm -f ${CONTAINER_NAME} || true
docker run -d --name ${CONTAINER_NAME} -p ${DOCKER_PORT}:${DOCKER_PORT} ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
if [ $? -eq 0 ]; then
    echo "Container is running."
else
    echo "Failed to run container."
    exit 1
fi

echo "===== Third Stage: Test Container ====="
docker ps | grep ${CONTAINER_NAME} > /dev/null
if [ $? -eq 0 ]; then
    echo "Container is running correctly."
else
    echo "Container test failed."
    exit 1
fi

echo "===== Fourth Stage: Push Image ====="
docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
if [ $? -eq 0 ]; then
    echo "Image pushed successfully."
else
    echo "Failed to push image."
    exit 1
fi

echo "===== Cleaning Up Local Image ====="
docker rmi ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
if [ $? -eq 0 ]; then
    echo "Local image removed successfully."
else
    echo "Failed to remove local image."
    exit 1
fi

echo "===== Fifth Stage: Play Ansible ====="
ansible-playbook -i inventory playbook.yml
if [ $? -eq 0 ]; then
    echo "Ansible playbook executed successfully."
else
    echo "Ansible playbook execution failed."
   exit 1
fi

echo "Pipeline completed successfully!"
