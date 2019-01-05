#!/bin/bash

if [ -f /opt/heating/heat-always ]; then
	state="always-on"
else 
	state="off"
fi

/opt/heating/set-heaters.sh $state
