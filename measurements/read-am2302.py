#!/usr/bin/python

import sys
import os
import signal
import Adafruit_DHT
import argparse
from time import strftime, sleep

class GracefulKiller:
    kill_now = False
    def __init__(self):
        signal.signal(signal.SIGINT, self.exit_gracefully)
        signal.signal(signal.SIGTERM, self.exit_gracefully)

    def exit_gracefully(self,signum, frame):
        self.kill_now = True

killer = GracefulKiller()

parser = argparse.ArgumentParser(description='Read AM2302 sensor data.')
parser.add_argument('pin', help='GPIO pin number (such as 22)')
parser.add_argument('-c', '--csv', dest='csv', action='store_true',
                    default=False, help='print output as csv')
parser.add_argument('-l', '--loop', dest='loop', type=int,
                    default=0, help='loop with LOOP time in seconds')
parser.add_argument('-t', '--time-from-file', dest='loop_time_file',
                    help='read loop time from file')
parser.add_argument('-f', '--file', dest='file', help='output values to file')
args = parser.parse_args()

sensor = Adafruit_DHT.AM2302 

# If we are writing to file and format is csv and file doesn't exist then
# first add header line
if args.csv and args.file is not None and not os.path.isfile(args.file):
    with open(args.file, "a") as output_file:
        output_file.write("datum,teplota,vlhkost\n")

loop_time = args.loop

while not killer.kill_now:

    # Try to grab a sensor reading.  Use the read_retry method which will retry up
    # to 15 times to get a sensor reading (waiting 2 seconds between each retry).
    humidity = 100.1
    while (humidity is None) or (humidity > 100.0):
        humidity, temperature = Adafruit_DHT.read_retry(sensor, args.pin)

    # Note that sometimes you won't get a reading and
    # the results will be null (because Linux can't
    # guarantee the timing of calls to read the sensor).
    # If this happens try again!
    if humidity is not None and temperature is not None:
        if args.csv:
            output = '{0}, {1:0.1f}, {2:0.1f}'.format(strftime("%Y-%m-%d %H:%M:%S"), temperature, humidity)
        else:
            output = 'Temp={0:0.1f}*  Humidity={1:0.1f}%'.format(temperature, humidity)
        if args.file is not None:
            with open(args.file, "a") as output_file:
                output_file.write(output + "\n")
        else:
            print(output)
    else:
        sys.stderr.write('Failed to get reading. Try again!')

    if args.loop is 0:
        break

    if args.loop_time_file is not None and os.path.isfile(args.loop_time_file):
        with open(args.loop_time_file) as f:
           loop_time = int(f.read()) 

    sleep(loop_time)
