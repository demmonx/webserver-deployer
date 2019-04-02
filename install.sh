#!/bin/bash
# This script install lemp-manager on your computer

# Base folder
. .env

# Change access right
chmod -R 774 "src/bin" "src/sbin"

# Load git submodules if we aren't in debug mode
echo "$@" | grep -- "--debug" > /dev/null
if [[ $? -ne 0 ]]; then
    echo "$@" | grep -- "--roles" > /dev/null
    if [[ $? -eq 0 ]]; then
        echo ""
        git submodule update --init --recursive
    else
        src/bin/private/asker "Load submodules"
        if [[ $? -eq 0 ]]; then
            git submodule update --init --recursive
        fi
    fi
else
    echo "--- DEBUG MODE ENABLED ---"
fi

# Remove previous install
rm -rf "$ROOT"
sed -i "/$MODULE_NAME/d" "$HOME/.bashrc"

# Create root folders
mkdir -p "$ROOT" "$BIN"  "$SBIN" "$ETC" "$TMP" "$CONF"

# Copy env to ROOT
cp .env "$ROOT"

# Copy <bin> to ROOT, and prefix with module name
cp -r src/bin/* "$BIN"
cp -r src/sbin/* "$SBIN"

# Copy src to /etc/lemp-manager
cp -r src/etc/* "$ETC"

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

# Add bin to .bashrc
echo "PATH=\$PATH:$BIN" >> "$HOME/.bashrc"
echo "PATH=\$PATH:$SBIN" >> "$HOME/.bashrc"

# DEBUG ONLY
echo "$@" | grep -- "--debug" > /dev/null
if [[ $? -eq 0 ]]; then
    echo "192.168.2.51  machineb" > "$VBOX"
    cp "example/machine.yml" "$CONF/192.168.2.51"
fi

# Show next instructions
echo "Success ! Now, run 'source $HOME/.bashrc' in order to have commands globally"


