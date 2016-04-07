#!/bin/bash

# setup_dokku_vm.sh

# Build base vm (kvm, libvirt) based on Ubuntu 14.04 minimal to use with dokku
# Felix Wolfsteller, 2015, 2016 GPL3+

if [ -z "$1" ]
  then
    echo "No argument supplied, call like '$0 <vm-name>'."
    exit 1
fi

VMNAME="$1"
USERHOME="$HOME"

sudo vmbuilder\
  kvm\
  ubuntu\
  --suite trusty\
  --flavour virtual\
  --arch amd64\
  --name "$VMNAME"\
  --hostname "$VMNAME"\
  --mem 1024\
  --cpus 1\
  --rootsize 20480\
  --swapsize 2048\
  --addpkg apparmor\
  --addpkg linux-image-generic\
  --addpkg openssh-server\
  --addpkg postgresql-client\
  --addpkg acpid\
  --user dokkulord\
  --ssh-user-key="$USERHOME"/.ssh/id_rsa.pub\
  --lock-user\
  --timezone Europe/Berlin\
  --libvirt qemu://system\
  --verbose\
  --execscript `pwd`/post_setup

