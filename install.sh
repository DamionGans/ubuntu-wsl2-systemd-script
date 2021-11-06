#!/bin/bash
set -ex

force_install=false
use_wslg_socket=true

while [[ $# -gt 0 ]] && [[ "$1" == "--"* ]] ;
do
    opt="$1";
    shift;              #expose next argument
    case "$opt" in
        "--" ) break 2;;
        "--force" )
           force_install="true";;
        "--force="* )     # alternate format: --force=true
           force_install="${opt#*=}";;
        "--no-wslg" )
           use_wslg_socket="false";;
        "--no-wslg="* )
           use_wslg_socket="${opt#*=}";;
        *) echo >&2 "Invalid option: $@"; exit 1;;
   esac
done

if [ "${force_install}" == "false" ]; then
    if [ -f /usr/sbin/start-systemd-namespace ]; then
        echo "It appears you have already installed the systemd hack."
        echo "To forcibly reinstall, run this script with the \`--force\` parameter."
        exit
    fi
    if [ -z "$WSL_DISTRO_NAME" ]; then
        echo "It appears that you are not running on WSL."
        echo "To forcibly install anyway, run this script with the \`--force\` parameter."
        exit
    fi
fi

self_dir="$(pwd)"

function interop_prefix {
  win_location="/mnt/"
  if [ -f /etc/wsl.conf ]; then
    tmp="$(awk -F '=' '/root/ {print $2}' /etc/wsl.conf | awk '{$1=$1;print}')"
    [ "$tmp" == "" ] || win_location="$tmp"
    unset tmp
  fi
  echo "$win_location"

  unset win_location
}

function sysdrive_prefix {
  win_location="$(interop_prefix)"
  hard_reset=0
  for pt in $(ls "$win_location"); do
    if [ $(echo "$pt" | wc -l) -eq 1 ]; then
      if [ -d "$win_location$pt/Windows/System32" ]; then
        hard_reset=1
        win_location="$pt"
        break
      fi
    fi 
  done

  if [ $hard_reset -eq 0 ]; then
    win_location="c"
  fi

  echo "$win_location"

  unset win_location
  unset hard_reset
}

sudo hwclock -s
install_packages=""
for package in daemonize dbus-user-session fontconfig; do
  if [ $(dpkg -l ${package} &> /dev/null; echo $?) -ne 0 ]; then
    install_packages+="${package} "
  fi
done

if [ ${#install_packages} -gt 0 ]; then
  sudo apt-get update && sudo apt-get install -yqq ${install_packages}
fi

sudo cp "$self_dir/start-systemd-namespace" /usr/sbin/start-systemd-namespace
sudo cp "$self_dir/enter-systemd-namespace" /usr/sbin/enter-systemd-namespace
sudo chmod +x /usr/sbin/enter-systemd-namespace

sudo tee /etc/sudoers.d/systemd-namespace >/dev/null <<EOF
Defaults        env_keep += WSLPATH
Defaults        env_keep += WSLENV
Defaults        env_keep += WSL_INTEROP
Defaults        env_keep += WT_PROFILE_ID
Defaults        env_keep += WT_SESSION
Defaults        env_keep += WSL_DISTRO_NAME
Defaults        env_keep += PRE_NAMESPACE_PATH
Defaults        env_keep += PRE_NAMESPACE_PWD
Defaults        env_keep += HOSTTYPE
Defaults        env_keep += NAME
Defaults        env_keep += USE_WSLG_SOCKET
$( [ "${use_wslg_socket}" == "true" ] && echo "Defaults        env_keep += PULSE_SERVER")
$( [ "${use_wslg_socket}" == "true" ] && echo "Defaults        env_keep += WAYLAND_DISPLAY")
$( [ "${use_wslg_socket}" == "true" ] && echo "Defaults        env_keep += DISPLAY")

%sudo ALL=(ALL) NOPASSWD: /usr/sbin/enter-systemd-namespace
EOF

sudo rm -f /etc/systemd/user/sockets.target.wants/dirmngr.socket
sudo rm -f /etc/systemd/user/sockets.target.wants/gpg-agent*.socket
sudo rm -f /lib/systemd/system/sysinit.target.wants/proc-sys-fs-binfmt_misc.automount
sudo rm -f /lib/systemd/system/sysinit.target.wants/proc-sys-fs-binfmt_misc.mount
sudo rm -f /lib/systemd/system/sysinit.target.wants/systemd-binfmt.service
sudo rm -f /etc/systemd/system/multi-user.target.wants/systemd-resolved.service
sudo rm -f /etc/systemd/system/dbus-org.freedesktop.resolve1.service
sudo rm -f /lib/systemd/system/systemd-networkd-wait-online.service
sudo rm -f /lib/systemd/system/systemd-networkd.service
sudo rm -f /lib/systemd/system/systemd-networkd.socket

if ! grep 'start-systemd-namespace' /etc/bash.bashrc >/dev/null; then
  sudo sed -i 2a"# Start or enter a PID namespace in WSL2\nexport USE_WSLG_SOCKET=${use_wslg_socket}\nsource /usr/sbin/start-systemd-namespace\n" /etc/bash.bashrc
else
  sudo sed -i "s/export USE_WSLG_SOCKET=.*/export USE_WSLG_SOCKET=${use_wslg_socket}/" /etc/bash.bashrc
fi



if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ] && [ "$(head -n1  /proc/sys/fs/binfmt_misc/WSLInterop)" == "enabled" ]; then
  "$(interop_prefix)$(sysdrive_prefix)"/Windows/System32/cmd.exe /C setx WSLENV BASH_ENV/u
  "$(interop_prefix)$(sysdrive_prefix)"/Windows/System32/cmd.exe /C setx BASH_ENV /etc/bash.bashrc
else
  echo
  echo "You need to manually run the following two commands in Windows' cmd.exe:"
  echo
  echo "  setx WSLENV BASH_ENV/u"
  echo "  setx BASH_ENV /etc/bash.bashrc"
  echo
fi
