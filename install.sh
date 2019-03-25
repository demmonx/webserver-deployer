#!/bin/bash
# This script install lemp-manager on your computer

# Base folder
. .env

# Remove previous install
rm -r "$ROOT"
sed "/$MODULE_NAME/d" "$HOME/.bashrc"

# Create root folders
mkdir "$ROOT" "$ROOT/bin" "$ROOT/etc" "$ROOT/tmp"

# Copy env to ROOT
cp .env "$ROOT"

# Copy <bin> to ROOT
cp bin/lemp-manager* "$ROOT/bin"

# Edit script to place env correctly
for file in "$ROOT/bin/"*; do
    sed -i "s@{ENV_LOCATION}@$ROOT/.env@" "$file"
done

# Copy src to /etc/lemp-manager
cp -r src/* "$ROOT/etc/"

# Edit vagrant file to set ansible files correctly
sed -i "s@{ANSIBLE_FOLDER}@$ANSIBLE_FOLDER@" "$VAGRANT_FILE.base"

# Change access right
chmod -R 755 "$ROOT"

# Add bin to .bashrc
echo "PATH=\$PATH:$ROOTbin" >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# Show next instructions
echo "Success ! Now, run 'source $HOME/.bashrc' in order to have commands globally"