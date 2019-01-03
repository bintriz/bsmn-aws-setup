#!/bin/bash

yum -y update

# Installing packages
yum -y install libcurl-devel gsl-devel # for bcftools
yum -y install readline-devel sqlite-devel # for python
yum -y install gcc72-c++ libXpm-devel xauth # for root
yum -y install tmux parallel emacs # etc 

# Timezone
if [[ -e /shared/config/timezone ]]; then
    TZ=$(</shared/config/timezone)
    sed -i '/ZONE/s|UTC|'$TZ'|' /etc/sysconfig/clock
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
    reboot
fi
