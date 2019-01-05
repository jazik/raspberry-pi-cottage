#!/usr/bin/python

import sys
import RPi.GPIO as GPIO

action_args = { 'on': GPIO.HIGH,
                'off': GPIO.LOW }
if len(sys.argv) == 3 and sys.argv[2] in action_args:
    pin = int(sys.argv[1])
    action = action_args[sys.argv[2]]
else:
    print('usage: sudo ' + sys.argv[0] + ' <gpio> <on/off>')
    print('example: sudo ' + sys.argv[0] + ' 5 on - switch GPIO 5 on')
    sys.exit(1)

# Output pins 5,6,13, old board 24

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(pin, GPIO.OUT)
GPIO.output(pin, action) 
if action == GPIO.LOW:
    GPIO.cleanup()
