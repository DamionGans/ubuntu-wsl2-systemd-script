#!/usr/bin/env fish

if test "$LOGNAME" != "root";
    echo "You need to run "(basename (status -f))" through sudo"
    exit 1
end

if test -x /usr/sbin/daemonize;
    set DAEMONIZE /usr/sbin/daemonize
else if test -x /usr/bin/daemonize;
    set DAEMONIZE /usr/bin/daemonize
else
    echo "Cannot execute daemonize to start systemd."
    exit 1
end

if ! command -s /lib/systemd/systemd > /dev/null;
    echo "Cannot execute /lib/systemd/systemd."
    exit 1
end

if ! command -s /usr/bin/unshare > /dev/null;
    echo "Cannot execute /usr/bin/unshare."
    exit 1
end

set SYSTEMD_EXE "/lib/systemd/systemd --unit=basic.target"
set SYSTEMD_PID (ps -eo pid=,args= | awk '$2" "$3=="'"$SYSTEMD_EXE"'" {print $1}')
if test -z "$SYSTEMD_PID";
    $DAEMONIZE /usr/bin/unshare --fork --pid --mount-proc fish -c 'export container=wsl; mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc; exec '"$SYSTEMD_EXE"
    while test -z "$SYSTEMD_PID"
        echo "Sleeping for 1 second to let systemd settle"
        sleep 1
        set SYSTEMD_PID (ps -eo pid=,args= | awk '$2" "$3=="'"$SYSTEMD_EXE"'" {print $1}')
    end
end

set USER_HOME (getent passwd | awk -F: '$1=="'"$SUDO_USER"'" {print $6}')
if test -n "$SYSTEMD_PID" && test "$SYSTEMD_PID" != "1";
    if test -n "$argv[1]" && "$argv[1]" != "fish --login" && "$argv[1]" != "/usr/bin/fish --login";
        exec /usr/bin/nsenter -t "$SYSTEMD_PID" -a \
            /usr/bin/sudo -H -u "$SUDO_USER" \
            /usr/bin/fish -c 'set -a; [ -f "$HOME/.systemd-env" ] && source "$HOME/.systemd-env"; set +a; exec fish -c '"(printf "%q" "$argv")"
    else
        exec /usr/bin/nsenter -t "$SYSTEMD_PID" -a \
            /bin/login -p -f "$SUDO_USER" \
            (test -f "$USER_HOME/.systemd-env" &&  /bin/cat "$USER_HOME/.systemd-env" | xargs printf ' %q' )
    end
    echo "Existential crisis"
    exit 1
end
