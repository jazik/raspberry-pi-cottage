#/bin/bash

set -x

. /opt/camera/camera-capture-upload-album

if [ "$ALBUM_TITLE" = "" ]
then
    echo "Image upload disabled!"
    exit 0
fi

if ! [ "$USER" = "pi" ]
then
    echo "I'm not user 'pi'!"
    exit 1
fi

if ! [ "$UID" = "1000" ]
then
    echo "I don't have uid 1000!"
    exit 1
fi

if ! [ "$HOME" = "/home/pi" ]
then
    echo "I don't have home /home/pi!"
    exit 1
fi

if [ "$#" -ne 1 ]
then
    echo "Usage: $0 <image>"
    echo "Example: $0 /opt/camera/images/20190113_1100.jpg"
    exit 1
fi

IMG_FILE=$1

export GOPATH=$HOME/go
export PATH=/usr/local/go/bin:$PATH:$GOPATH/bin

if ! [ -x "$(command -v gpup)" ]; then
    echo 'Error: gpup is not installed.' >&2
    exit 1
fi

gpup -a "$ALBUM_TITLE" $IMG_FILE

