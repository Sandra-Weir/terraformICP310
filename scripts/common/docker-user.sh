#!/bin/bash

# Some RHEL based installations may not have docker installed yet.
# Only attempt to add user to group if docker is installed and the user is not root

echo "=================================================="
echo "=== docker-user.sh"
echo "=================================================="

if grep -q docker /etc/group
then
  iam=$(whoami)

  if [[ $iam != "root" ]]
  then
    sudo usermod -a -G docker $iam
  fi
fi

echo "=================================================="
echo "=== End of docker-user.sh"
echo "=================================================="

