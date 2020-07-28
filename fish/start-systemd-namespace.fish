#!/usr/bin/env fish
if status --is-interactive
set SYSTEMD_EXE "/lib/systemd/systemd --unit=basic.target"
set SYSTEMD_PID (ps -eo pid=,args= | awk '$2" "$3=="'"$SYSTEMD_EXE"'" {print $1}')
if test \( "$LOGNAME" != "root" \) && test -z "$SYSTEMD_PID" -o "$SYSTEMD_PID" != "1";
    set -xL | sed -e '/^IFS=".*[^"]$/{N;s/\n//}' | \
        grep -E -v "^(BASH|BASH_ENV|DIRSTACK|EUID|GROUPS|HOME|HOSTNAME|\
IFS|LANG|LOGNAME|MACHTYPE|MAIL|NAME|OLDPWD|OPTERR|\
OSTYPE|PATH|PIPESTATUS|POSIXLY_CORRECT|PPID|PS1|PS4|\
SHELL|SHELLOPTS|SHLVL|SYSTEMD_PID|UID|USER|_)(=|\$)" > "$HOME/.systemd-env"
    set -x PRE_NAMESPACE_PATH $PATH
    set -x PRE_NAMESPACE_PWD (pwd)
    exec sudo /etc/fish/conf.d/enter-systemd-namespace $BASH_EXECUTION_STRING
end
if test -n "$PRE_NAMESPACE_PATH";
    set -x PATH $PRE_NAMESPACE_PATH
    set -u PRE_NAMESPACE_PATH
end
if test -n "$PRE_NAMESPACE_PWD";
    cd $PRE_NAMESPACE_PWD
    set -u PRE_NAMESPACE_PWD
end
end
