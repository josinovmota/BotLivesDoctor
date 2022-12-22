#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $dir/..
path() {
  echo $1
}

################################################################################
# IO
################################################################################

. $(path $dir/io.sh)

################################################################################
# Update system
################################################################################

io_info "updating system ...\n"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get -yq --allow-downgrades --allow-remove-essential --allow-change-held-packages upgrade
io_success "system updated\n"

################################################################################
# Docker
################################################################################

io_info "removing previous versions of docker ...\n"
sudo apt-get -yq remove docker docker-engine docker.io containerd runc
sudo apt-get -yq autoremove
io_success "old docker version removed\n"

io_info "installing docker ...\n"
sudo apt-get -yq install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -yq install docker-ce docker-ce-cli containerd.io docker-compose-plugin
io_success "docker installed\n"

################################################################################
# Docker Compose
################################################################################

io_info "installing docker compose ...\n"
sudo curl -L "https://github.com/docker/compose/releases/download/v2.14.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
io_success "docker compose installed\n"
