#!/usr/bin/env bash

# Constant
FILES_FOLDER="$HOME/.ansible-vagrant-lemp.d/"
HOSTS="$FILES_FOLDER/hosts"
ANSIBLE_FOLDER="../src/ansible"

# Create file if not exists
touch "$HOSTS"

# Process
ansible-playbook "$ANSIBLE_FOLDER/playbook.yml" -i "$HOSTS"
