TMPDIR ?= /var/tmp

all:
  @echo Run \'sudo make install\' to install.
 
install:
  @echo Online install for Ubuntu WSL2 systemd Hack
  curl https://raw.githubusercontent.com/wackyblackie/ubuntu-wsl2-systemd-script/master/ubuntu-wsl2-systemd-script.sh | bash
  @echo Run \'sudo make disable\' to disable systemd hack
  @echo Run \'sudo make uninstall\' to uninstall systemd hack
 
 uninstall:
  @echo Online uninstall for Ubuntu WSL2 systemd Hack
  curl https://raw.githubusercontent.com/wackyblackie/ubuntu-wsl2-systemd-script/master/uninstall.sh | bash
 
 disable:
  @echo Offline systemd Hack disable
  @sudo grep -v "source /usr/sbin/start-systemd-namespace" /etc/bash.bashrc > $(TMPDIR)/tmpfile && mv $(TMPDIR)/tmpfile /etc/bash.bashrc
  @echo Run \'sudo make uninstall\' to fully uninstall
  
