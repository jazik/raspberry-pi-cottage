#!/bin/bash

# https://github.com/vincenthsu/systemd-ngrok

systemctl daemon-reload
systemctl enable ngrok.service
systemctl start ngrok.service
