#!/usr/bin/env bash

# FILES
HOSTS=/etc/hosts
VBOX=vbox
DEL_VBOX=del_vbox

# Check if user is root or no
if [ "$EUID" -ne 0 ]
  then echo "You need to be root to edit /etc/hosts !"
  exit
fi

# Update IFS
OFIS=$IFS
IFS=\n

# Files creation if isn't exists
touch "$VBOX"
touch "$DEL_VBOX"

# Add new vbox to host file
for box in $(cat "$VBOX"); do
    name=$(echo "$box" | awk '{print $2}')
    exists=$(cat "$HOSTS" | grep "$name")
    if [[ ! $exists ]]; then
        echo "$box" >> "$HOSTS"
    fi
done

# Remove deleted vbox
for box in $(cat "$DEL_VBOX"); do
    name=$(echo "$box" | awk '{print $2}')
    sed -i "/\s$name$/d" "$HOSTS"
    sed -i "/\s$name$/d" "$DEL_VBOX"
done

# Reset IFS
IFS="$OIFS"