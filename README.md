# Room Control
By Vidmantas Valskis


## Description

Room Control is an IoT project to help you control your rooms' environment. It measures Humidity levels in the room, saves the data in SQL dabatase, takes a photograph of window sill (because every morning there's puddles of water on it) and uploades it to the server. The mobile app, will allow you to see recent Humidity readings and the latest photograph as well as take the photograph on the Raspberry Pi.


## Equipment needed

* Raspberry Pi
* SenseHat
* Raspberry Pi Camera Module
* Android device


## Dependencies

* NodeJS
   ```
   npm install express
   npm install multer
   npm install mysql
   ```
* SQL database (MariaDB)
   * For CentOS follow https://mariadb.com/resources/blog/installing-mariadb-10-on-centos-7-rhel-7/
* Flutter SDK
   * Android Studio
    * Follow https://docs.flutter.dev/get-started/install


## Mobile app screenshots (Emulator & Android phone)
<img width="261" alt="image" src="https://user-images.githubusercontent.com/29129335/208768270-57816965-197b-44ad-8c3e-3c253a82067c.png"><img width="238" alt="image" src="https://user-images.githubusercontent.com/29129335/208767175-723ff1c5-c323-402b-b4a0-924f763810b2.png">

## Workflow & Logic
<img width="481" alt="image" src="https://user-images.githubusercontent.com/29129335/208773019-4f9f3b0a-4e67-4d50-9965-de7abb35de13.png">


## Authors

* Name : Vidmantas Valskis


## Acknowledgments

Sources referred to during the development of the assignment:
* [Uploading files using node.js](https://github.com/expressjs/multer)
* [Node.js API with Express](https://www.bezkoder.com/node-js-rest-api-express-mysql/)
* [Libraries for Flutter](https://pub.dev/packages)



