#!/bin/bash
# This script install lemp-manager on your computer

# Base folder
. .env

# Load git submodules
echo "$@" | grep "--debug" > /dev/null
if [[ $? -eq 0 ]]; then
    bin/private/asker "Load submodules"
    if [[ $? -eq 0 ]]; then
        #for folder in "find src/ansible/roles -type d"; do
        #    cd "$folder"
            git submodule init 
            git submodule update
        #done
    fi
fi

# Remove previous install
rm -rf "$ROOT"
sed -i "/$MODULE_NAME/d" "$HOME/.bashrc"

# Create root folders
mkdir -p "$ROOT" "$BIN" "$ETC" "$TMP" "$CONF"

# Copy env to ROOT
cp .env "$ROOT"

# Copy <bin> to ROOT, and prefix with module name
cp bin/* "$BIN"

# Copy src to /etc/lemp-manager
cp -r src/* "$ETC"

# Edit filenames
previous_folder=$(pwd)
cd "$BIN"
for f in * ; do mv -- "$f" "$MODULE_NAME-$f" ; done
mv "$MODULE_NAME-main" "$MODULE_NAME"

# Edit script to place env correctly
for file in "$BIN/"*; do
    sed -i "s@{ENV_LOCATION}@$ROOT/.env@" "$file"
    sed -i "s@{MODULE_NAME}@$MODULE_NAME@" "$file"
    sed -i "s@{BIN_PRIVATE}@$BIN_PRIVATE@" "$file"
done

# Edit vagrant file to set ansible files correctly
sed -i "s@{ANSIBLE_PLAYBOOK}@$ANSIBLE_PLAYBOOK@" "$VAGRANT_FILE.base"
sed -i "s@{ANSIBLE_INVENTORY}@$ANSIBLE_INVENTORY@" "$VAGRANT_FILE.base"

# Edit ansible file to set up links
sed -i "s@{ANSIBLE_VARS}@$ANSIBLE_VARS@" "$ANSIBLE_PLAYBOOK"

# Change access right
chmod -R 755 "$ROOT"

# Add bin to .bashrc
echo "PATH=\$PATH:$BIN" >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# DEBUG ONLY
echo "$@" | grep "--debug" > /dev/null
if [[ $? -eq 0 ]]; then
    echo "--- DEBUG MODE ENABLED ---"
    cd "$previous_folder"
    echo "192.168.2.50  machine" > "$VBOX"
    cp "example/machine.yml" "$CONF/192.168.2.50"
fi

# Show next instructions
echo "Success ! Now, run 'source $HOME/.bashrc' in order to have commands globally"


