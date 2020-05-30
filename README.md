# ubuntu-wsl2-systemd-script
Script to enable systemd support on current Ubuntu WSL2 images from the Windows store. 
Tested on 18.04, 20.04 and the versionless (current) version of Ubuntu from the Windows Store.
I am not responsible for broken installations, fights with your roommates and police ringing your door ;-).

Instructions from [the snapcraft forum](https://forum.snapcraft.io/t/running-snaps-on-wsl2-insiders-only-for-now/13033) turned into a script. Thanks to [Daniel](https://forum.snapcraft.io/u/daniel) on the Snapcraft forum! 

## Usage
### Run the script and commands
```sh
curl "https://raw.githubusercontent.com/DamionGans/ubuntu-wsl2-systemd-script/master/ubuntu-wsl2-systemd-script.sh" | bash
# Enter your password and wait until the script has finished
```
### Then restart the Ubuntu shell and try running systemctl
```sh
systemctl

```
If you don't get an error and see a list of units, the script worked.

Have fun using systemd on your Ubuntu WSL2 image. You may use and change and distribute this script in whatever way you'd like. 
