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
    if [ "$action" != "disabled" -a "$action" != "always-on" ]
    then
        $HEATERS_PATH/$heater $action
    fi
    echo "$date ---- $heater $action" >> /var/log/heating
done
