#!/bin/bash

sudo apt-get -y update
sudo apt-get -y install gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-libav

sudo apt-get -y install python-pip
sudo python -m pip install --upgrade pip setuptools wheel
sudo pip install Adafruit_DHT

sudo pip install RPi.GPIO

sudo pip install w1thermsensor

sudo dpkg-reconfigure -f noninteractive tzdata

sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen en_US.UTF-8
sudo update-locale en_US.UTF-8

