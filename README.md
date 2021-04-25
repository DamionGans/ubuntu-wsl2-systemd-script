# ubuntu-wsl2-systemd-script

Fork of the [archived repo](https://github.com/DamionGans/ubuntu-wsl2-systemd-script) of DamionGans. 
I fixed it to make it work better with VSCode & snap.

Script to enable systemd support on current Ubuntu WSL2 images from the Windows store. 
I am not responsible for broken installations, fights with your roommates and police ringing your door ;-).

Instructions from [the snapcraft forum](https://forum.snapcraft.io/t/running-snaps-on-wsl2-insiders-only-for-now/13033) turned into a script. Thanks to [Daniel](https://forum.snapcraft.io/u/daniel) on the Snapcraft forum! 

## Usage
You need ```git``` to be installed for the commands below to work. Use
```sh
sudo apt install git
```
to do so.

### Run the script and commands
```sh
git clone https://github.com/FiestaLake/ubuntu-wsl2-systemd-script.git ~/ubuntu-wsl2-systemd-script
cd ~/ubuntu-wsl2-systemd-script
bash install.sh
# Enter your password and wait until the script has finished.
```

### Restart the Ubuntu shell and try running systemctl
```sh
systemctl
```
If you don't get an error and see a list of units, the script worked fine.

### Uninstalling
```sh
cd ~/ubuntu-wsl2-systemd-script
bash uninstall.sh
# Enter your password and wait until the script has finished.
```

Have fun using systemd on your Ubuntu WSL2 image. 
You may use and change and distribute this script by following LICENSE.md.
