#!/bin/bash

source /etc/*cluster/cfnconfig

IFS=,

[[ -f /shared/config/user.list ]] && grep -v ^# /shared/config/user.list \
|while read user uid; do
    if ! id $user >/dev/null 2>&1; then
        if [[ $cfn_node_type = "MasterServer" ]]; then
            useradd -u $uid -g ec2-user $user
            if [[ -f /shared/config/user_public_key/id_rsa.$user.pub ]]; then
                mkdir /home/$user/.ssh
                cat /shared/config/user_public_key/id_rsa.$user.pub \
                    > /home/$user/.ssh/authorized_keys
                chown -R $user:ec2-user /home/$user/.ssh
                chmod -R go-rwx /home/$user/.ssh
            fi
        else
            useradd -M -u $uid -g ec2-user $user
        fi
    fi
done
