#!/bin/bash

sudo apt-get -y update --allow-releaseinfo-change
sudo apt-get -y install gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-libav

# If we are running Desktop then install touch screen keyboard
# in case physical keyboard is not attached.
TARGET=`systemctl get-default`
if [ "$TARGET" = "graphical.target" ]; then
    sudo apt-get -y install matchbox-keyboard
fi

sudo apt-get -y install python-pip
sudo python -m pip install --upgrade pip setuptools wheel
sudo pip install Adafruit_DHT

sudo pip install RPi.GPIO

sudo pip install w1thermsensor

sudo dpkg-reconfigure -f noninteractive tzdata

sudo sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen en_US.UTF-8
sudo update-locale en_US.UTF-8

sudo apt-get -y install git
GO_VER=1.11.4
wget https://dl.google.com/go/go$GO_VER.linux-armv6l.tar.gz
sudo tar -C /usr/local -xzf go$GO_VER.linux-armv6l.tar.gz
rm go$GO_VER.linux-armv6l.tar.gz

export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin
go get -v -u github.com/int128/gpup

sudo apt-get -y install lighttpd
sudo chown -R www-data:www-data /var/www
sudo sh -c 'cd /etc/lighttpd/conf-enabled; ln -s ../conf-available/10-cgi.conf 10-cgi.conf'
sudo sed -i -e 's/\s.*cgi.assign.*/\tcgi.assign = ( ".py" => "\/usr\/bin\/python" )/' /etc/lighttpd/conf-enabled/10-cgi.conf
sudo sed -i -e '/\s.*url.alias/d' /etc/lighttpd/conf-enabled/10-cgi.conf
sudo systemctl restart lighttpd
