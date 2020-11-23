#!/bin/bash
if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$1"
fi

cd2=$(pwd)
#sudo apt update -yqqqq
echo "Uninstalling ubuntu-wsl2-systemd-hack"
sudo rm -f /usr/sbin/start-systemd-namespace
sudo rm -f /usr/sbin/enter-systemd-namespace
cd /var/tmp
sudo grep -v "source /usr/sbin/start-systemd-namespace" /etc/bash.bashrc > tmpfile && mv tmpfile /etc/bash.bashrc
cd $cd2
