#!/bin/bash

DATE=$(date +"%Y%m%d-%H%M")
IMG_FILE=/opt/camera/images/$DATE.jpg

raspistill -o $IMG_FILE

sudo -H -u pi bash -c "/opt/camera/camera-capture-upload.sh $IMG_FILE"

