#!/bin/bash

ARGUMENT_LIST=(
    "timezone"
)

# read arguments
opts=$(getopt \
    --longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
    --name "$(basename "$0")" \
    --options "" \
    -- "$@"
)

eval set --$opts

while [[ $# -gt 0 ]]; do
    case "$1" in
        --timezone)
            TZ=$2
            shift 2
            ;;

        *)
            break
            ;;
    esac
done

# Installing packages
yum -y update
yum -y install libcurl-devel gsl-devel # for compiling bcftools
yum -y install readline-devel sqlite-devel # for compiling python
yum -y install gcc72-c++ libXpm-devel xauth # for compiling root
yum -y install gd gd-devel # gd library for GD perl module
yum -y install tmux parallel emacs # etc

# Fix the location of omp.h.
ln -s /usr/lib/gcc/x86_64-amazon-linux/4.8.5/include/omp.h /usr/local/include/

# Timezone
ZONEINFO=$(find /usr/share/zoneinfo -type f|sed 's|/usr/share/zoneinfo/||') 
if [[ ! -z "$TZ" ]] && [[ $ZONEINFO =~ (^|[[:space:]])"$TZ"($|[[:space:]]) ]]; then
    sed -i '/ZONE/s|UTC|'$TZ'|' /etc/sysconfig/clock
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
    reboot
fi
