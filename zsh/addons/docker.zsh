#!/usr/bin/env zsh

# Function to list out all images, containers and volumes
function dls() {
  printf "\nImages\n"
  docker images
  printf "\nContainers\n"
  docker ps -a
  printf "\nVolumes\n"
  docker volume ls
}