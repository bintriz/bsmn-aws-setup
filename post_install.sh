#!/bin/bash

yum -y update

# EFS
if [[ -e /shared/config/efs_id ]]; then
    yum -y install amazon-efs-utils
    fs_id=$(</shared/config/efs_id)
    echo "${efs_id}:/ /efs efs _netdev" >> /etc/fstab
    mount -a -t efs defaults
fi

# Additional packages
if [[ -e /shared/config/packages ]]; then
    for package in $(grep -v ^# /shared/config/packages); do
        yum -y install $package
    done
fi

# Timezone
if [[ -e /shared/config/timezone ]]; then
    TZ=$(</shared/config/timezone)
    sed -i '/ZONE/s|UTC|'$TZ'|' /etc/sysconfig/clock
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
fi

reboot
