#!/bin/bash


apt-get update -y
apt-get upgrade -y
apt-get install -y git docker.io

sudo usermod -aG docker $USER
newgrp docker

systemctl enable docker
systemctl start docker


mkdir -p /root/.ssh
chmod 700 /root/.ssh


#cat <<EOF > /root/.ssh/authorized_keys
#ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIdu4IH22X9AAklK2GjvaJAKU2gfXFo+fF0HzgsfztIm ali@wsl
#EOF

#chmod 600 /root/.ssh/authorized_keys


#ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
#chmod 600 /root/.ssh/known_hosts


#git clone git@github.com:aliaminsalah/project.git


docker pull aliamin10/webweather:latest
#docker run  -d -p 5000:5000 aliamin10/webweather 
