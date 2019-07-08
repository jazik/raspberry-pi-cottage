#!/bin/bash

systemctl daemon-reload
systemctl enable measurements.service
systemctl start measurements.service
