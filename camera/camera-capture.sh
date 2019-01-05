#!/bin/bash

DATE=$(date +"%Y%m%d-%H%M")

raspistill -o /opt/camera/images/$DATE.jpg
