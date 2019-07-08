# raspberry-pi-cottage

Set of scripts for Raspberry Pi to create little cottage automation device
with camera, temperature and humidity sensors with possibility to control
electrical heating.

You may enable use of your ngrok account to tunnel through firewalls
and enable camera streaming or periodic snapshots. You can configure
temperature sensors either AM2302 or DS18B20 to take periodic measurements
and store those to a file. Or you can control outputs to switch on/off
electrical heating.

When camera captures are enabled they can be optionally uploaded to
Google Photos.

Project contains simple WebUI running on top of `lighttpd` and implemented
in Javascript using [Plotly](https://plot.ly/) to display measured
temperature and humidity. The data collections must be enabled after
installation by running `/opt/measurements/measurements-systemd-enable.sh`.

Note that this is for Linux host only. It won't work on Windows or MacOS
or any other host.

# Configuration

There are some private configuration data required to be created such
as ssh keys, ngrok token, wifi ssid name and password etc. Easiest is
to start with [examples](examples).

Make sure you keep your private personal data secure, don't store those
in Github or any public cloud.

## Camera capture upload to Google Photos

The scripts are using [gpup](https://github.com/int128/gpup) Go application
to upload images to Google Photos using API. It requires to OAuth authentication.
Follow the instructions along with `gpup`.

If you don't have web browser installed on Raspberry then get the token
in your desktop machine and then update the [.gpupconfig](examples/custom/.gpupconfig)
accordingly.

In [/opt/camera/camera-capture-upload-album](camera/camera-capture-upload-album)
uncomment the `ALBUM_TITLE` and set the string to Google Photos album to which
the images should be uploaded.

Once image capturing is enabled the image will be also automatically uploaded.

# Creating SD card for Raspberry Pi

You will need an SD card at least 4 GB in size, Raspberry Pi board,
camera and temperature sensors. Eventually simple transistor circuitry
if you will be controlling your electrical heater as well.

To create ready to use SD card run following assuming your SD card
is `/dev/sdb`:

```
git https://github.com/jazik/raspberry-pi-cottage.git
cd raspberry-pi-cottage
./create.sh /dev/sdb examples/custom mywifi
```

This will download latest Raspbian Lite image and modify the configuration
based on your customization and including helper scripts for controlling
camera, heaters and temperature measurements.

# First boot

After SD card is ready a post installatio is required to be done. You should
be able to `ssh` to the board using user 'pi' and your ssh keys. The board
will use DHCP so you need to check assigned IP address in your wifi router.

```
ssh -i examples/custom/wifi/mywifi/id_rsa pi@192.168.0.2
./post-install.sh
sudo reboot
```

This will install additional packages on top of Raspbian Lite needed for
camera use and use of temperature sensors. It will also configure timezone
and locales. Check the script for details.

# Use

By default all the peripherals are not really taken into use. Look at
`/opt/` directory for scripts to enable and further configure each of
the peripherals.

There is not much further documentation but the scripts are simple and should
serve as good starting point.
