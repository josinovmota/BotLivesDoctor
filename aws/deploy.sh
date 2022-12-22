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
# Update local code
################################################################################

io_info "updating local bot version ...\n"
git fetch
git pull
io_success "local bot version updated\n"

################################################################################
# Update docker image to latest version
################################################################################

io_info "retrieving code version ...\n"
tag="$( git describe --tags )"
io_success "code version found : $tag\n"

io_info "checking if there is a docker image for the founded tag ...\n"
if [ "$( sudo docker images | grep botlivesdoctor | grep $tag )" ]
then
    io_success "docker image for current version already founded\n"
    exit 0
fi

io_info "building docker image ...\n"
sudo docker build -t botlivesdoctor:$tag .
io_success "docker image builded\n"

################################################################################
# updating docker compose
################################################################################

io_info "updating the docker compose yaml ...\n"
sed "s|<tag>|$tag|g" < "$(path $dir/../docker-compose.template)" > "$(path $dir/../docker-compose.yaml)"
io_success "docker compose yaml updated\n"

################################################################################
# updating running container
################################################################################

io_info "updating running container ...\n"
sudo docker-compose up -d
io_success "running container updated\n"
