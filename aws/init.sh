#!/bin/bash

################################################################################
# IO
################################################################################

io_buffer=()
io_buffer[0]=""
io_index=0

io_push() { io_index=$io_index+1; io_buffer[$io_index]=""; }
io_pop() { io_buffer[$io_index]=""; io_index=$io_index-1; }

io_clear() { io_write "\e[0m"; }
io_bold()  { io_write "\e[1m"; }
io_red()   { io_write "\e[31m"; }
io_green() { io_write "\e[32m"; }
io_blue()  { io_write "\e[34m"; }

io_write() { local cur="${io_buffer[$io_index]}"; io_buffer[$io_index]="$cur${@}"; }
io_write_bold() { io_bold; io_write "${@}"; io_clear; }
io_write_red() { io_bold; io_red; io_write "${@}"; io_clear; }
io_write_green() { io_bold; io_green; io_write "${@}"; io_clear; }
io_write_blue() { io_bold; io_blue; io_write "${@}"; io_clear; }
io_flush() { local cur="${io_buffer[$io_index]}"; printf "${cur[@]}"; io_buffer[$io_index]=""; }

io_info_header() { io_write_blue "▶"; }
io_info() { io_info_header; io_write " ${@}"; io_flush; }
io_success_header() { io_write_green "✔"; }
io_success() { io_success_header; io_write_green " ${@}"; io_flush; }
io_fail_header() { io_write_red "✗"; }
io_fail() { io_fail_header; io_write_red " ${@}"; io_flush; }

################################################################################
# Update system
################################################################################

# update system
io_info "updating system ...\n"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get -yq --allow-downgrades --allow-remove-essential --allow-change-held-packages upgrade
io_success "system updated\n"

################################################################################
# Docker
################################################################################

# uninstall current version of docker
io_info "removing previous versions of docker ...\n"
sudo apt-get -yq remove docker docker-engine docker.io containerd runc
sudo apt-get -yq autoremove
io_success "old docker version removed\n"

# install docker
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
# Prepare docker image
################################################################################
