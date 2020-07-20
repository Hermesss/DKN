#!/bin/bash
# Install docker, git
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common git
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker ubuntu

# Install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# READ MORE: https://docs.docker.com/install/linux/docker-ce/ubuntu/
# To check: grep "cloud-init\[" /var/log/syslog
#       OR: less /var/log/cloud-init-output.log

# Manually add user to docker group
sudo usermod -aG docker $USER
# fetch git repo
git clone https://github.com/ask4ua/DKN
#build docker image
docker build ./DKN/Practices/Section2/Stage1/db/ -t db
#run docker image overriding secrets
docker run  -d --name db --env POSTGRES_DB=${POSTGRES_DB} --env POSTGRES_USER=${POSTGRES_USER} --env POSTGRES_PASSWORD=${POSTGRES_PASSWORD} -p 5432:5432 db