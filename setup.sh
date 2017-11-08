#!/bin/env sh
set -e

scriptUser=`logname`

if [[ ! `xcode-select -v` ]]; then
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

if [[ ! -d /apps ]]; then
  mkdir -p /apps
  chown $scriptUser /apps
fi

if [[ ! -d /apps/mac-dev-setup ]]; then
  git clone git@github.com:anthonycrobinson/mac-dev-setup.git /apps/mac-dev-setup
  chown -R $scriptUser /apps/mac-dev-setup
else
  cd /apps/mac-dev-setup && git pull
fi

cd /appps/mac-dev-setup && ansible-playbook main.yml

