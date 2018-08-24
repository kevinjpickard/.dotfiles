#!/bin/bash -x

sudo -v

# for some reason, when this suite is run on an Arch Linux host pacman errors out due 
# to some conflicting files and I don't feel like finding a proper fix right now so
# TODO: Do better.
if [[ -d /usr/include/rpcsvc ]]; then
  sudo rm -rf /usr/include/rpcsvc
fi

if [[ -e /usr/lib/libnsl.so ]]; then
  sudo rm /usr/lib/libnsl.so
fi

if [[ $OSTYPE == darwin* ]]; then
  read -s SUDO_PASSWD
  read HOST_NAME
  echo "Detected MacOS"
  echo $SUDO_PASSWD
  echo "Installing updates..."
  softwareupdate -lia

  echo "Installing HomeBrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  echo "Brew installed. Installing Ansible..."
  brew install ansible

  echo "Ansible installed. Cloning files..."
  brew install git
  git clone -b arch https://github.com/kevinjpickard/.dotfiles.git ~/.dotfiles

  echo "Executing playbook..."
  sudo ansible-playbook --connection=local ~/.dotfiles/core.yml --extra-vars "username=$USER hostname=$HOST_NAME ansible_sudo_pass=$SUDO_PASSWD" -vvv
else
  # Using command -v for POSIX compatibility
  if command -v ansible-playbook > /dev/null; then
    echo 'Ansible is already installed'
  else
    echo 'Ansible is not installed, installing now...'
    sudo pacman -Syyu --noconfirm --needed ansible
  fi

  if [[ -e /tmp/kitchen/core.retry ]]; then
    ANSIBLE_LIBRARY="/tmp/kitchen/library/aur:$ANSIBLE_LIBRARY" ansible-playbook --connection=local /tmp/kitchen/core.yml --extra-vars "username=kevin hostname=KJP-test" --limit @/tmp/kitchen/core.retry -vvv
  else
    ANSIBLE_LIBRARY="/tmp/kitchen/library/aur:$ANSIBLE_LIBRARY" ansible-playbook --connection=local /tmp/kitchen/core.yml --extra-vars "username=kevin hostname=KJP-test nvidia=true" -vvv
  fi
fi

