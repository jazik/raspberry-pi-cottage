#!/bin/bash

systemctl daemon-reload
systemctl enable camera.service
systemctl start camera.service
