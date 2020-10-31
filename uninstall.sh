#!/bin/bash
if [ "$(id -u)" != "0" ]; then
  exec sudo "$0" "$1"
fi

#sudo apt update -yqqqq
echo "Uninstalling ubuntu-wsl2-systemd-hack"
sudo rm -f /usr/sbin/start-systemd-namespace
sudo rm -f /usr/sbin/enter-systemd-namespace
sudo sed -i "s/#\ Start\ or\ enter\ a\ PID\ namespace\ in\ WSL2\nsource\ \/usr\/sbin\/start-systemd-namespace\n//g" /etc/bash.bashrc
