import socket
import time
from datetime import datetime, timedelta
from sense_hat import SenseHat
from picamera import PiCamera

camera = PiCamera()
sense = SenseHat()
sense.clear()
frame = 1
green = (0, 180, 0)
red = (255, 0, 0)
color = (200, 0, 200)
# set location of image file and current time
picLoc = f'/home/pi/photos/frame{frame}.jpg'
host = "vimo.lt"
port = 25999                   # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.sendall(b'Its a me, Mario')
# print('Received', repr(data))
date = datetime.now()
date2 = datetime.now()

while True:
    now = datetime.now()
    if now > date2 + timedelta(seconds=1):
        s.sendall(bytes("0", "utf-8"))
        sense.show_message("Send nudes", scroll_speed=0.06, text_colour=red)
        data = s.recv(1024).decode()
        if int(data) > 0:
            print('darom fotke')
            # currentTime = datetime.datetime.now().strftime("%d/%m/%Y %H:%M:%S")
            # picLoc = f'/home/pi/photos/frame{frame}.jpg'
            camera.capture(picLoc)  # capture image and store in fileLoc
            frame += 1
        date2 = now
    if now > date + timedelta(seconds=10):
        humid = sense.get_humidity()
        if humid >= 25:
            text = str(humid)
            s.sendall(bytes(text, "utf-8"))
        else:
            sense.show_message("vava", text_colour=green)
        print(humid)
        date = now
