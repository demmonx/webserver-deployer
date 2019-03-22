#!/bin/bash
# This script install lemp-manager on your computer

# Base folder
. bin/.env
ROOT="$FILES_FOLDER"

# Create root folders
mkdir "$ROOT" "$ROOT/bin" "$ROOT/etc"

# Copy <bin> to ROOT
cp bin/lemp-manager* "$ROOT/bin"

# Copy src to /etc/lemp-manager
cp -r src/* "$ROOT/etc/"

# Edit vagrant file to set ansible files correctly
sed -i "s/{ANSIBLE_FOLDER}/$ANSIBLE_FOLDER/" "$VAGRANT_FILE.base"

# Change access right
chmod -R 755 "$ROOT"

# Add bin to .profile
echo "PATH=$PATH:$ROOT/bin" >> "$HOME/.profile"
source "$HOME/.profile"

