#!/bin/bash

echo "Hello, This is my final project for Dhub!"

GREEN="\033[32m"
RESET='\033[0m'

#Env
DOCKER_REGISTRY='aliamin10'
IMAGE_NAME='webweather'
CONTAINER_NAME='weather-app'
DOCKER_PORT='5000'

#Stages

echo "===== First Stage: Build Image ====="
docker build -t ${IMAGE_NAME}:latest .
if [ $? -eq 0 ]; then
     echo -e "${GREEN}Image built successfully.${RESET}"
else
    echo "Failed to build image."
    exit 1
fi

echo "===== Second Stage: Run Container ====="
docker rm -f ${CONTAINER_NAME} || true
docker run -d --name ${CONTAINER_NAME} -p ${DOCKER_PORT}:${DOCKER_PORT} ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Container is running.${RESET}"
else
    echo "Failed to run container."
    exit 1
fi

echo "===== Third Stage: Test Container ====="
docker ps | grep ${CONTAINER_NAME} > /dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Container is running correctly.${RESET}"
else
    echo "Container test failed."
    exit 1
fi

echo "===== Fourth Stage: Push Image ====="
docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
if [ $? -eq 0 ]; then
   echo -e "${GREEN}Image pushed successfully.${RESET}"
else
   echo "Failed to push image."
   exit 1
fi

echo "===== Cleaning Up Local Image ====="
docker rmi ${IMAGE_NAME}:latest
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Local image removed successfully.${RESET}"
else
    echo "Failed to remove local image."
    exit 1
fi

echo "===== Fifth Stage: Play Ansible ====="
ansible-playbook -i inventory playbook.yml
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Ansible executed successfully.${RESET}"
else
    echo "Ansible playbook execution failed."
   exit 1
fi

echo -e "${GREEN}Pipeline completed successfully!${RESET}"
