#!/bin/bash

HEATERS_PATH=/opt/heating/heaters.d

if [ "$#" -ne 1 ]
then
    echo "Usage: $0 <on/off/disabled/always-on>"
    echo "Example: $0 on"
    exit 1
fi

action=$1

date=`date` 
for heater in `ls -1 $HEATERS_PATH/.`
do
    do_action=$action
    if [ -f /opt/heating/$heater-disabled ]; then
        do_action="disabled"
    fi

    if [ "$do_action" != "disabled" -a "$do_action" != "always-on" ]
    then
        $HEATERS_PATH/$heater $do_action
    fi
    echo "$date ---- $heater $do_action" >> /var/log/heating
done
