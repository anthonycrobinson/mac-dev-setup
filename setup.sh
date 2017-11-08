#!/bin/env sh
set -e

scriptUser=`logname`

if [[ ! `xcode-select -p` ]]; then
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l |
    grep "\*.*Command Line" |
    head -n 1 | awk -F"*" '{print $2}' |
    sed -e 's/^ *//' |
    tr -d '\n')
  softwareupdate -i "$PROD" --verbose;
fi

if [[ ! `pip -V` ]]; then
  easy_install pip
fi

if [[ ! `ansible --version` ]]; then
  pip install ansible
fi

if [[ ! -d /home/$scriptUser/.ansible/roles/geerlingguy.homebrew ]]; then
  su - $scriptUser -l -c 'ansible-galaxy install geerlingguy.homebrew'
fi

if [[ ! -d /apps ]]; then
  mkdir -p /apps
  chown $scriptUser /apps
fi

if [[ ! -d /apps/mac-dev-setup ]]; then
  su - $scriptUser -c 'git clone https://github.com/anthonycrobinson/mac-dev-setup.git /apps/mac-dev-setup'
else
  su - $scriptUser -c 'cd /apps/mac-dev-setup && git pull'
fi

su - $scriptUser -l -c 'cd /apps/mac-dev-setup && ansible-playbook main.yml -K'
