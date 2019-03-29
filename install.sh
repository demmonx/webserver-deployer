#!/bin/bash
# This script install lemp-manager on your computer

# Base folder
. .env

# Load git submodules
echo "$@" | grep -- "--roles" > /dev/null
if [[ $? -eq 0 ]]; then
    echo ""
    git submodule update --init --recursive
else
    bin/private/asker "Load submodules"
    if [[ $? -eq 0 ]]; then
        git submodule update --init --recursive
    fi
fi

# Remove previous install
rm -rf "$ROOT"
sed -i "/$MODULE_NAME/d" "$HOME/.bashrc"

# Create root folders
mkdir -p "$ROOT" "$BIN"  "$SBIN" "$ETC" "$TMP" "$CONF"

# Copy env to ROOT
cp .env "$ROOT"

# Copy <bin> to ROOT, and prefix with module name
cp -r bin/* "$BIN"
cp -r sbin/* "$SBIN"

# Copy src to /etc/lemp-manager
cp -r src/* "$ETC"

# Edit filenames
for f in $(find $BIN $SBIN -maxdepth 1 -type f); do 
    folder=${f%/*}
    name=$(basename $f)
    mv -- "$f" "$folder/$MODULE_NAME-$name" ; 
done
mv "$BIN/$MODULE_NAME-main" "$BIN/$MODULE_NAME"

# Edit files to install absolute path
for file in $(find $ROOT -not \( -path $ANSIBLE_ROLES -prune \) -type f); do
    sed -i "s@{ENV_LOCATION}@$ROOT/.env@" "$file"
    sed -i "s@{MODULE_NAME}@$MODULE_NAME@" "$file"
    sed -i "s@{BIN_PRIVATE}@$BIN_PRIVATE@" "$file"
    
done

# Change access right
chmod -R 775 "$ROOT"
chmod -R 774 "$SBIN"
chown -R root:root "$SBIN"

# Add bin to .bashrc
echo "PATH=\$PATH:$BIN" >> "$HOME/.bashrc"
echo "secure_path=\$secure_path:$SBIN" >> "$HOME/.bashrc"

# DEBUG ONLY
echo "$@" | grep -- "--debug" > /dev/null
if [[ $? -eq 0 ]]; then
    echo "--- DEBUG MODE ENABLED ---"
    echo "192.168.2.51  machineb" > "$VBOX"
    cp "example/machine.yml" "$CONF/192.168.2.51"
fi

# Show next instructions
echo "Success ! Now, run 'source $HOME/.bashrc' in order to have commands globally"


