#!/bin/bash

if [ -f /usr/sbin/start-systemd-namespace ] && [ "$1" != "--force" ]; then
  echo "It appears you have already installed the systemd hack."
  echo "To forcibly reinstall, run this script with the \`--force\` parameter."
  exit
fi

self_dir="$(dirname $0)"

sudo apt-get update && sudo apt-get install -yqq git daemonize dbus-user-session fontconfig

git clone https://github.com/DamionGans/ubuntu-wsl2-systemd-script.git
cd ubuntu-wsl2-systemd-script

sudo cp "$self_dir/start-systemd-namespace" /usr/sbin/start-systemd-namespace
sudo cp "$self_dir/enter-systemd-namespace" /usr/sbin/enter-systemd-namespace
sudo chmod +x /usr/sbin/enter-systemd-namespace

sudo tee /etc/sudoers.d/systemd-namespace <<EOF
Defaults        env_keep += WSLPATH
Defaults        env_keep += WSLENV
Defaults        env_keep += WSL_INTEROP
Defaults        env_keep += WSL_DISTRO_NAME
Defaults        env_keep += PRE_NAMESPACE_PATH
Defaults        env_keep += PRE_NAMESPACE_PWD
%sudo ALL=(ALL) NOPASSWD: /usr/sbin/enter-systemd-namespace
EOF

sudo sed -i 2a"# Start or enter a PID namespace in WSL2\nsource /usr/sbin/start-systemd-namespace\n" /etc/bash.bashrc

if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ] && [ "$(head -n1  /proc/sys/fs/binfmt_misc/WSLInterop)" == "enabled" ]; then
  cmd.exe /C setx WSLENV BASH_ENV/u
  cmd.exe /C setx BASH_ENV /etc/bash.bashrc
fi
