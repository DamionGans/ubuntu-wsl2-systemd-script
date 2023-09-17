# ubuntu-wsl2-systemd-script
Script to enable systemd support on current Ubuntu WSL2 images from the Windows store. 
Tested on 18.04, 20.04, 20.10 versions of Ubuntu from the Windows Store.
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
git clone https://github.com/alanmburr/ubuntu-wsl2-systemd-script.git
cd ubuntu-wsl2-systemd-script/
bash ubuntu-wsl2-systemd-script.sh
# Enter your password and wait until the script has finished
```
### Then restart the Ubuntu shell and try running systemctl
```sh
systemctl

```
If you don't get an error and see a list of units, the script worked.

### Disabling from a broken shell
To disable this script (in any case), just press <kbd>Win</kbd> + <kbd>R</kbd> and type `wsl.exe -u root` and press <kbd>Enter</kbd>.
Then, continue the steps in the [Uninstalling section](#Uninstalling)


### Uninstalling
To uninstall open your distro and type:
```sh
git clone https://github.com/alanmburr/ubuntu-wsl2-systemd-script.git
cd ubuntu-wsl2-systemd-script
bash uninstall.sh
# Enter your [sudo] password to uninstall.
```

Have fun using systemd on your Ubuntu WSL2 image.
