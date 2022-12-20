import socket
import requests
from datetime import datetime, timedelta
from sense_hat import SenseHat
from picamera import PiCamera

frequency = 10
camera = PiCamera()
sense = SenseHat()
sense.clear()
# set location of image file and current time
picLoc = f'/home/pi/photos/frame1.jpg'
# set url of image file to upload
uploadUrl = "http://vimo.lt:25998/upload"
files = {'image': open('/home/pi/photos/frame1.jpg', 'rb')}
# set your own host IP or domain address
host = "vimo.lt"
# set the same port as used by your TCP server
port = 25999
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.sendall(b'Its a me, Mario')
date = datetime.now()
date2 = datetime.now()


def photo():
    print('taking a photo')
    camera.capture(picLoc)
    # upload the photo to your web server
    print('uploading the photo')
    files = {'image': open('/home/pi/photos/frame1.jpg', 'rb')}
    r = requests.post(uploadUrl, files=files)
    serverMsg = r.text
    if serverMsg == 'done':
        print(serverMsg)
        s.sendall(bytes("new_photo", "utf-8"))


# check on TCP server every second if there's any requests & send humidity readings every 10 secods.
while True:
    now = datetime.now()
    if now > date2 + timedelta(seconds=1):
        s.sendall(bytes("0", "utf-8"))
        data = s.recv(1024).decode()
        if int(data) > 0:
            photo()
        date2 = now
    if now > date + timedelta(seconds=frequency):
        humid = sense.get_humidity()
        if humid >= 25:
            text = str(humid)
            s.sendall(bytes(text, "utf-8"))
        print(humid)
        date = now
