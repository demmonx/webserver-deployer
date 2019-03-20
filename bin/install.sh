#!/usr/bin/env bash

# Default values
ram=512
cpu=1

# Constant
FILES_FOLDER="$HOME/.ansible-vagrant-lemp.d/"
HOSTS="$FILES_FOLDER/hosts"
VBOX="$FILES_FOLDER/box"

VAGRANT_FOLDER="src/vagrant"
VAGRANT_FILE="$VAGRANT_FOLDER/Vagrantfile"

ANSIBLE_FOLDER="src/ansible"
INVENTORY="$ANSIBLE_FOLDER/inventory"


# Create files if don't exists
mkdir -p "$FILES_FOLDER"
touch "$HOSTS"
touch "$VBOX"

# Show command details
function usage()
{
    echo "How to deploy a VM :"
    echo "./install.sh -h --help"
    echo "./install.sh --name=... --ip=... [--cpu=nb --ram=nb (mb)]"
}

# Verify that CPU is numeric and valid values
function checkCPU()
{
    isValid=$(echo "$1" | grep '^[1-8]$')
    if [[ ! $isValid ]]; then
        echo "CPU must be between 1 and 8 (--cpu=1)"
        exit 1;
    fi
 }

# Verify that the ram is numeric and enough
function checkRAM() {
    isValid=$(echo "$1" | grep '^[0-9]\{3,\}$')
    if [[ ! $isValid || $1 -le 511  ]]; then
        echo "RAM must be at least 512mb (--ram=512)"
        exit 1;
    fi
 }

# Verify if the ip looks correct and not used
function checkIP() {
    isValid=$(echo "$1" | grep -P '(?<=[^0-9.]|^)[1-9][0-9]{0,2}(\.([0-9]{0,3})){3}(?=[^0-9.]|$)')
    if [[ ! $isValid ]]; then
        echo "Isn't a valid IPV4"
        exit 1;
    fi

    exists=$(cat "$HOSTS" | grep -i -e "$1")
    if [[ $exists ]]; then
        echo "VirtualMachine with the same IP already exist"
        exit 1;
    fi
 }

# Verify the name of the virtualbox (correct and not used)
function checkName() {
    isValid=$(echo "$1" | grep "^[a-zA-Z]\{4,\}$" )
    if [[ ! $isValid ]]; then
        echo "Virtual Machine name must be composed with only [a-zA-Z] chars (min length : 4)"
        exit 1;
    fi

    exist=$(cat "$VBOX" | grep -i -e " $1$")
    if [[ $exists ]]; then
        echo "VirtualMachine with the same name already exist"
        exit 1;
    fi
 }

# Parse command line
if [[ $# -eq 0 ]]; then # Error, no args provided
    usage
    exit 1
elif [[ $# -eq 1 && ( $1 == "--help" || $1 == "-h") ]]; then # Help asked
    usage
    exit 0
fi

# At least the name and the ip are provided
nameExist=$(echo $@ | grep -i -e '--name=')
ipExist=$(echo $@ | grep -i -e '--ip=')
if [[ ! $nameExist || ! $ipExist ]]; then
    usage
    exit 1;
fi

# Match param with value and check format (to be done)
while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --cpu)
            checkCPU "$VALUE"
            cpu="$VALUE"
            ;;
        --ram)
            checkRAM "$VALUE"
            ram="$VALUE"
            ;;
        --name)
            checkName "$VALUE"
            name="$VALUE"
            ;;
        --ip)
            checkIP "$VALUE"
            ip="$VALUE"
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

cd ..

# Clone files
cp "$VAGRANT_FILE.base" "$VAGRANT_FILE"
cp "$INVENTORY.base" "$INVENTORY"

# Apply config
sed -i "s/{NAME}/$name/g"  "$VAGRANT_FILE"
sed -i "s/{RAM}/$ram/g"  "$VAGRANT_FILE"
sed -i "s/{CPU}/$cpu/g"  "$VAGRANT_FILE"
sed -i "s/{IP}/$ip/g"  "$VAGRANT_FILE"

sed -i "s/{NAME}/$name/g"  "$INVENTORY"
sed -i "s/{IP}/$ip/g"  "$INVENTORY"

# Install and deploy VM
cd "$VAGRANT_FOLDER"
vagrant up

# Stop if error
if [[ $? -ne 0 ]]; then
    echo "Aborted"
    exit 1
fi


# Update hosts files
echo "$ip" >> "$HOSTS"
echo "$ip     $name" >> "$VBOX"

# Clean config files
cd ../..
rm "$VAGRANT_FILE"
rm "$INVENTORY"
