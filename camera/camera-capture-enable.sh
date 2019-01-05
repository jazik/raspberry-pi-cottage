#!/bin/bash

cp /opt/camera/camera-capture-crontab /etc/cron.d/.
systemctl restart cron
