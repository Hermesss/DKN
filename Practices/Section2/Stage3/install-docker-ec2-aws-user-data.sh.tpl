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
git clone https://github.com/ask4ua/DKN
sed -i "s~server web2:80;~server web2:80;\nserver ${proxy1_ip}:8081;\nserver ${proxy1_ip}:8082;\nserver ${proxy2_ip}:8081;\nserver ${proxy2_ip}:8082;~" ./DKN/Practices/Section2/Stage2/proxy/nginx.conf
docker network create mynet 
docker build ./DKN/Practices/Section2/Stage2/proxy/ -t proxy
docker build ./DKN/Practices/Section2/Stage1/web/ -t web
docker run -d --name web1 -p 8081:80 --env DBHOST=${db_address} --env DBNAME=${POSTGRES_DB} --env DBUSER=${POSTGRES_USER} --env DBPASS=${POSTGRES_PASSWORD} --network mynet web 
docker run -d --name web2 -p 8082:80 --env DBHOST=${db_address} --env DBNAME=${POSTGRES_DB} --env DBUSER=${POSTGRES_USER} --env DBPASS=${POSTGRES_PASSWORD} --network mynet web 
docker run -d --name proxy -p 80:80 --network mynet proxy