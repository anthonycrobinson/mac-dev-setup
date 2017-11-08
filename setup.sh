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

mkdir -p /apps
chown $scriptUser /apps

