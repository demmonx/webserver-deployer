#!/usr/bin/env bash

# FILES
HOSTS="/etc/hosts"
FILES_FOLDER="$HOME/.ansible-vagrant-lemp.d/"
VBOX="$FILES_FOLDER/box"
DEL_VBOX="$FILES_FOLDER/del_vbox"

# Check if user is root or no
if [ "$EUID" -ne 0 ]
  then echo "You need to be root to edit /etc/hosts !"
  exit
fi

# Update IFS
OIFS=$IFS
IFS='\n'

# Files creation if isn't exists
touch "$VBOX"
touch "$DEL_VBOX"

# Add new vbox to host file
while IFS='' read -r line || [[ -n "$line" ]]; do
    name=$(echo "$line" | awk '{print $2}')
    cat "$HOSTS" | grep "$name$" > /dev/null
    if [[ $? -ne 0 ]]; then
        echo "$line" >> "$HOSTS"
    fi
done < "$VBOX"

# Remove deleted vbox
while IFS='' read -r line || [[ -n "$line" ]]; do
    name=$(echo "$line" | awk '{print $1}')
    sed -i "/$name$/d" "$HOSTS"
    sed -i "/$name$/d" "$DEL_VBOX"
done < "$DEL_VBOX"

# Reset IFS
IFS="$OIFS"