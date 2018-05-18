#
# update PS1
#

case $- in
    *i*) 
        # don't put duplicate lines or lines starting with space in the history.
        if [ "$(id -u)" = 0 ]; then
            PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        else
            PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
        fi
        ;;
      *);;
esac

