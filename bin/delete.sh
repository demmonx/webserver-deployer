#!/usr/bin/env bash

# FILES
FILES_FOLDER="$HOME/.ansible-vagrant-lemp.d/"
VBOX="$FILES_FOLDER/box"
DEL_VBOX="$FILES_FOLDER/del_vbox"

usage() {
    echo "delete.sh vbox1 [vbox2 ....]"
}

# Check there is at least 1 PM
if [[ $# -eq 0 ]]; then # Error, no args provided
    usage
    exit 1
fi

# Check all the machines
for name in $@; do
    # Check machine name
    cat "$VBOX" | grep -i -e "$name$"  > /dev/null
    if [[ $? -ne 0 ]]; then
        echo "No VirtualMachine with this name : $name"
        continue
    fi

    # Halt virtual machine
    vboxmanage controlvm "$name" shutdown 2> /dev/null

    # Remove VM
    vboxmanage unregistervm --delete "$name"
    if [[ $? -ne 0 ]]; then
        echo "Error removing : $name"
        continue
    fi

    # Remove machine from active hosts
    sed -i "/\s$name$/d" "$VBOX"
    echo "$name" >> "$DEL_VBOX"
done