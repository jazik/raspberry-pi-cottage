#!/bin/bash

if [ ! -f /opt/heating/heat-during-low-tariff ]; then
	state="disabled"
else 
	state="on"
fi

/opt/heating/set-heaters.sh $state
