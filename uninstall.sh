#!/bin/bash

self_dir=$(pwd)

echo "Uninstalling ubuntu-wsl2-systemd-script"

sudo rm -rf /usr/sbin/start-systemd-namespace
sudo rm -rf /usr/sbin/enter-systemd-namespace
sudo rm -rf /etc/sudoers.d/systemd-namespace

cd /var/tmp
if [ -f "/etc/bash.bashrc" ]; then
sudo grep -v "# Start or enter a PID namespace in WSL2
export USE_WSLG_SOCKET=false
export USE_WSLG_SOCKET=true
source /usr/sbin/start-systemd-namespace" /etc/bash.bashrc > tmpfile
sudo mv tmpfile /etc/bash.bashrc
fi

cd $self_dir
