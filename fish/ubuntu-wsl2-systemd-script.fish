#!/usr/bin/env fish

if test \( -f /usr/sbin/start-systemd-namespace \)  -a \( "$argv[1]" != "--force" \) ;
  echo "It appears you have already installed the systemd hack."
  echo "To forcibly reinstall, run this script with the \`--force\` parameter."
  exit
end

set self_dir (pwd)

function interop_prefix

	set win_location "/mnt/"
	if test -f /etc/wsl.conf;
		set tmp (awk -F '=' '/root/ {print $2}' /etc/wsl.conf | awk '{$1=$1;print}')
		test \( "$tmp" == "" \) -o \( win_location="$tmp" \)
		set -u tmp
	end
	echo "$win_location"

	set -u win_location
end

function sysdrive_prefix 
	set win_location (interop_prefix)
	set hard_reset 0
	for pt in (ls "$win_location"); do
		if test (echo "$pt" | wc -l) -eq 1;
			if test -d "$win_location$pt/Windows/System32";
				set hard_reset 1
				set win_location "$pt"
				break
			end
		end 
	end

	if test $hard_reset -eq 0;
		set win_location "c"
	end

	echo "$win_location"

	set -u win_location
	set -u hard_reset
end

sudo hwclock -s
sudo apt-get update && sudo apt-get install -yqq daemonize dbus-user-session fontconfig

sudo cp "$self_dir/start-systemd-namespace.fish" /etc/fish/conf.d/start-systemd-namespace.fish
sudo cp "$self_dir/enter-systemd-namespace.fish" /etc/fish/conf.d/enter-systemd-namespace
sudo chmod +x /etc/fish/conf.d/enter-systemd-namespace

echo "
Defaults        env_keep += WSLPATH
Defaults        env_keep += WSLENV
Defaults        env_keep += WSL_INTEROP
Defaults        env_keep += WSL_DISTRO_NAME
Defaults        env_keep += PRE_NAMESPACE_PATH
Defaults        env_keep += PRE_NAMESPACE_PWD
%sudo ALL=(ALL) NOPASSWD: /etc/fish/conf.d/enter-systemd-namespace
" | sudo tee /etc/sudoers.d/systemd-namespace >/dev/null 

sudo rm -f /etc/systemd/user/sockets.target.wants/dirmngr.socket
sudo rm -f /etc/systemd/user/sockets.target.wants/gpg-agent*.socket
sudo rm -f /lib/systemd/system/sysinit.target.wants/proc-sys-fs-binfmt_misc.automount
sudo rm -f /lib/systemd/system/sysinit.target.wants/proc-sys-fs-binfmt_misc.mount
sudo rm -f /lib/systemd/system/sysinit.target.wants/systemd-binfmt.service
