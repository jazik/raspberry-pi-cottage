#!/bin/bash

ownip=`hostname -I`
ownip=127.0.0.1
raspivid -n -t 0 -h 200 -w 320 -fps 25 -b 2000000 -o - | gst-launch-1.0 -v fdsrc ! h264parse ! rtph264pay config-interval=1 pt=96 ! gdppay ! tcpserversink host=$ownip port=5000
