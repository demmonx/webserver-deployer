#!/usr/bin/env bash

# FILES
VBOX=vbox
DEL_VBOX=del_vbox

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
    exist=$(cat "$VBOX" | grep -i -e " $name$")
    if [[ !$exists ]]; then
        echo "No VirtualMachine with this name : $name"
        continue
    fi

    # Halt virtual machine
    vagrant destroy "$name"
    if [[ $? -ne 0 ]]; then
        echo "Error halting : $name"
        continue
    fi 

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