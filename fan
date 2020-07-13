import RPi.GPIO as gpio
import sys
import subprocess as sp
from time import sleep
GND_PIN = 37

on = False
def turnon():
    print("Turning On")
    gpio.output(GND_PIN, 1)

def off():
    print("Turning Off")
    gpio.output(GND_PIN, 0)

gpio.setmode(gpio.BOARD)
gpio.setup(GND_PIN, gpio.OUT)
off()
print("Starting the app")
try:
    while True:
        #sleep(19)
        temp = sp.check_output(["cat", "/sys/class/thermal/thermal_zone0/temp"]).decode('utf-8')
        temp = int(temp)/1000.0
        print("current temp : %f and current state : %s" % (temp, on))
        if on and temp <40 :
            off()
            on = False
        elif not on and temp > 50:
            turnon()
            on = True
        sleep(5)
except :
    e = sys.exc_info()[0]
    print(e)
    print("Erorr")
finally:
    print("Cleaning up")
    gpio.cleanup()
