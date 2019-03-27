#!/bin/bash
# This script install lemp-manager on your computer

# Base folder
. .env

# Load git submodules
echo "$@" | grep -- "--roles" > /dev/null
if [[ $? -eq 0 ]]; then
    submodule update --init --recursive
else
    bin/private/asker "Load submodules"
    if [[ $? -eq 0 ]]; then
        submodule update --init --recursive
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
cp -r bin/* "$BIN"

# Copy src to /etc/lemp-manager
cp -r src/* "$ETC"

# Edit filenames
for f in $(find $BIN -maxdepth 1 -type f); do 
    name=$(basename $f)
    mv -- "$f" "$BIN/$MODULE_NAME-$name" ; 
done
mv "$BIN/$MODULE_NAME-main" "$BIN/$MODULE_NAME"

# Edit files to install absolute path
for file in $(find $ROOT -not \( -path $ANSIBLE_ROLES -prune \) -type f); do
    sed -i "s@{ENV_LOCATION}@$ROOT/.env@" "$file"
    sed -i "s@{MODULE_NAME}@$MODULE_NAME@" "$file"
    sed -i "s@{BIN_PRIVATE}@$BIN_PRIVATE@" "$file"
    sed -i "s@{ANSIBLE_PLAYBOOK}@$ANSIBLE_PLAYBOOK@" "$file"
    sed -i "s@{ANSIBLE_INVENTORY}@$ANSIBLE_INVENTORY@" "$file"
    sed -i "s@{ANSIBLE_VARS}@$ANSIBLE_VARS@" "$file"
done

# Change access right
chmod -R 755 "$ROOT"

# Add bin to .bashrc
echo "PATH=\$PATH:$BIN" >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# DEBUG ONLY
echo "$@" | grep -- "--debug" > /dev/null
if [[ $? -eq 0 ]]; then
    echo "--- DEBUG MODE ENABLED ---"
    echo "192.168.2.50  machine" > "$VBOX"
    cp "example/machine.yml" "$CONF/192.168.2.50"
fi

# Show next instructions
echo "Success ! Now, run 'source $HOME/.bashrc' in order to have commands globally"


