#!/usr/bin/python

import sys
from w1thermsensor import W1ThermSensor

if len(sys.argv) == 2:
    sensor_id = sys.argv[1]
else:
    print('usage: sudo ' + sys.argv[0] + ' <sensor id>')
    print('example: sudo ' + sys.argv[0] + ' 00000588806a - Read from an DS18B20 wiht id 00000588806a')
    sys.exit(1)

sensor = W1ThermSensor(W1ThermSensor.THERM_SENSOR_DS18B20, sensor_id)
temperature_in_celsius = sensor.get_temperature()
print('Temp={0:0.1f}*'.format(temperature_in_celsius))

