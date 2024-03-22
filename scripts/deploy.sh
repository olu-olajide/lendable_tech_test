#!/bin/bash

# Initialize default values
EC2_INSTANCE_ID=""
IMAGE_TAG="latest"
SSH_KEY_PATH=""
EC2_PUBLIC_DNS=""

# Parse command-line options
while getopts i:t:k:d: option
do
case "${option}"
in
i) EC2_INSTANCE_ID=${OPTARG};;
t) IMAGE_TAG=${OPTARG};;
k) SSH_KEY_PATH=${OPTARG};;
d) EC2_PUBLIC_DNS=${OPTARG};;
esac
done

# Commands to run on the EC2 instance
COMMANDS_TO_RUN="
  docker pull oluay87/lendable_tech_test:$IMAGE_TAG &&
  docker stop web-container || true &&
  docker rm web-container || true &&
  docker run --name web-container -d -p 80:80 oluay87/lendable_tech_test:$IMAGE_TAG
"

# Execute the commands on the EC2 instance via SSH
ssh -i "$SSH_KEY_PATH" ec2-user@"$EC2_PUBLIC_DNS" "$COMMANDS_TO_RUN"
