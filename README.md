# Room Control
By Vidmantas Valskis


## Description

Room Control is an IoT project to help you control your rooms' environment. It measures Humidity levels in the room, saves the data in SQL dabatase, takes a photograph of window sill (because every morning there's puddles of water on it) and uploades it to the server. The mobile app, will allow you to see recent Humidity readings and the latest photograph as well as take the photograph on the Raspberry Pi.


## Equipment needed

* Raspberry Pi
* SenseHat
* Raspberry Pi Camera Module
* Android device
* VPS


## Dependencies

* NodeJS
   ```
   npm install express
   npm install multer
   npm install mysql
   ```
* SQL database (MariaDB)
   * For CentOS follow https://mariadb.com/resources/blog/installing-mariadb-10-on-centos-7-rhel-7/
   * Run `room_control.sql` to create the database & table.
* Flutter SDK
   * Android Studio
    * Follow https://docs.flutter.dev/get-started/install


## Mobile app screenshots (Emulator & Android phone)
<img width="261" alt="image" src="https://user-images.githubusercontent.com/29129335/208768270-57816965-197b-44ad-8c3e-3c253a82067c.png"><img width="238" alt="image" src="https://user-images.githubusercontent.com/29129335/208767175-723ff1c5-c323-402b-b4a0-924f763810b2.png">

## Workflow & Logic
<img width="481" alt="image" src="https://user-images.githubusercontent.com/29129335/208773019-4f9f3b0a-4e67-4d50-9965-de7abb35de13.png">


## Get started:
   1) Make sure you have all dependencies installed.
   2) Upload `API_server` folder & `tcp_server.js` file to your VPS (Suggest using any Linux distro).
   3) Change Database & Port info inside of `API_server/config/db.config.js` and `tcp_server.js`
   4) I suggest using `screen` or `tmux` for launching both servers:
      * `cd API_server` & `node server.js`
         * On successful launch you shoud see "Server is running on port 25998. Successfully connected to the database."
      * `node tcp_server.js`
         * On successful launch you shoud see "Server started on port 25999".
   5) Upload pi_scripts/humid-sensor.py to your Raspberry Pi, place it in your room and run the script:
      * `python3 humid-sensor.py`
         * On successful launch you shoud see "pi connected" in your TCP server terminal (window).
         * You can modifty the `frequency` variable in humid-sensor.py to adjust how often Pi is going to send readings to TCP server.
   6) You can either use Android Studio and an emulator, or install the app directly with APK package included in the latest release.
   7) Control your room.

## Tips:
   * You can use `screen` or `tmux` on any linux distro to launch the servers and be able to return to their terminal/console at any given time.
   * You can set up `humid-sensor.py` script on your Raspberry Pi `crontab -e` to launch on it's own after every reboot - `@reboot sleep 30 && python3 /home/pi/scripts/humid-sensor.py > /dev/null 2>&1`

## Acknowledgments

Sources referred to during the development of the project:
* [Uploading files using node.js](https://github.com/expressjs/multer)
* [Node.js API with Express](https://www.bezkoder.com/node-js-rest-api-express-mysql/)
* [Libraries for Flutter](https://pub.dev/packages)



