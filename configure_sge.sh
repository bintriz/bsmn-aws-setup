#!/bin/bash

source /etc/*cluster/cfnconfig

if [[ $cfn_node_type = "MasterServer" ]] && ! qconf -sp threaded >/dev/null 2>&1; then
    cat >/tmp/threaded.conf <<END
pe_name            threaded
slots              99999
user_lists         NONE
xuser_lists        NONE
start_proc_args    NONE
stop_proc_args     NONE
allocation_rule    \$pe_slots
control_slaves     FALSE
job_is_first_task  TRUE
urgency_slots      min
accounting_summary TRUE
qsort_args         NONE
END
    qconf -Ap /tmp/threaded.conf
    qconf -mattr queue pe_list threaded all.q
    rm /tmp/threaded.conf
fi
