#!/bin/bash

if [ "$#" -lt 3 ]
then
    echo "Usage: $0 [-g] <sd card device> <custom dir> <wifi>"
    echo "    -g....install desktop version of raspbian"
    echo "Example: $0 /dev/sdb examples/custom mywifi"
    exit 1
fi

if [ "$1" = "-g" ]; then
    VARIANT=""
    shift
else
    VARIANT="_lite"
fi

SD_DEV=$1
CUSTOM_DIR=$2
WIFI=$3

IMAGE=raspbian${VARIANT}_latest

mkdir -p download
cd download
rm -f *.img
rm -f $IMAGE.sha1.new
curl -JL https://downloads.raspberrypi.org/$IMAGE.sha1 -o $IMAGE.sha1.new
cmp -s $IMAGE.sha1.new $IMAGE.sha1
if [ $? -ne 0 ] 
then
    echo "New version of Raspbian exist."
    read -p "Do you want to download new version? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm -f *.zip.old
        rename zip zip.old *.zip || true
        mv $IMAGE.sha1 $IMAGE.sha1.old || true
        curl -JLO https://downloads.raspberrypi.org/$IMAGE
        sha1sum --quiet --check $IMAGE.sha1.new
        if [ $? -ne 0 ]
        then
            echo "Checksum failed exiting ..."
            rename zip.old zip *.zip || true
            mv $IMAGE.sha1.old $IMAGE.sha1 || true
            exit 1
        fi
        mv $IMAGE.sha1.new $IMAGE.sha1
    else
        echo "Not downloading latest version of Raspbian."
    fi
else
    echo "Already have latest version of Raspbian."
fi
rm -f $IMAGE.sha1.new

rm -f ngrok-stable-linux-arm.zip
curl -JLO https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
curl -JLO https://raw.githubusercontent.com/vincenthsu/systemd-ngrok/master/ngrok.service

for file in `ls -1 *.zip`;do unzip $file; done

cd ..

if [ ! -e "$SD_DEV" ]
then
    echo "SD card device $SD_DEV doesn't exist!"
    exit 1
fi

mount | grep "$SD_DEV" | sed -e 's/ .*//' | xargs -r umount

read -p "Do you want to really overwrite $SD_DEV? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborting."
    exit 1
fi

sudo dd if=`ls download/*.img` of=$SD_DEV bs=8M status=progress
sync

mkdir mnt || true
sudo mount "$SD_DEV"2 mnt
sudo sh -c 'mkdir mnt/opt'

sudo sh -c "cat $CUSTOM_DIR/wifi/$WIFI/wpa_supplicant.conf >> mnt/etc/wpa_supplicant/wpa_supplicant.conf"

sudo sh -c 'cp -rT target mnt/home/pi'
sudo sh -c "cp -p $CUSTOM_DIR/keys/* mnt/home/pi/.ssh/."
sudo sh -c "cp -p $CUSTOM_DIR/.gpupconfig mnt/home/pi/."
sudo sh -c 'chown -R 1000:1000 mnt/home/pi'
sudo sh -c 'cp -r heating mnt/opt/.'
sudo sh -c 'cp -r measurements mnt/opt/.'
sudo sh -c 'cp -r camera mnt/opt/.'
sudo sh -c 'cp camera/camera.service mnt/etc/systemd/system/'

sudo sh -c 'mkdir mnt/opt/ngrok'
sudo sh -c 'cp ngrok/*.sh mnt/opt/ngrok/.'
sudo sh -c "cat $CUSTOM_DIR/ngrok/ngrok.yml.in > mnt/opt/ngrok/ngrok.yml"
sudo sh -c 'cat ngrok/ngrok.yml.out >> mnt/opt/ngrok/ngrok.yml'
sudo sh -c 'mv download/ngrok mnt/opt/ngrok/'
sudo sh -c 'mv download/ngrok.service mnt/etc/systemd/system/'

sudo sh -c 'sed -i -e "s/.*PasswordAuthentication.*/PasswordAuthentication no/" mnt/etc/ssh/sshd_config'

sudo sh -c 'rm -f mnt/etc/localtime'
sudo sh -c "cp $CUSTOM_DIR/timezone mnt/etc/timezone"

sudo sync
sleep 1
sudo umount mnt

sudo mount "$SD_DEV"1 mnt
sudo sh -c 'touch mnt/ssh'
sudo sh -c 'cat config/config.txt >> mnt/config.txt'
sudo sync
sleep 1
sudo umount mnt

rmdir mnt
rm download/*.img
rm download/ngrok-stable-linux-arm.zip

echo "SD card ready!"
