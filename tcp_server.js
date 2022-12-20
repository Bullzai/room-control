const mysql = require('mysql');
const net = require('net');

const con = mysql.createConnection({
  host: "your_host_address",
  user: "your_user",
  password: "your_password",
  database: "your_database_name"
});

con.connect(function (err) {
  if (err) throw err;
  console.log("Connected!");
});

const port = 25999;
const server = net.createServer(onClientConnection);
let pi;
let piSock;
// Keep track of the clients
let clientSocks = [];

server.listen(port, function () {
  console.log(`Server started on port ${port}`);
});

function onClientConnection(sock) {
  console.log(`${sock.remoteAddress}:${sock.remotePort} Connected`);
  // Put this new client in the list
  clientSocks.push(sock);
  // Handle the client data
  sock.on('data', function (data) {
    //Log data received from the client
    console.log(`>> data received : ${data} `);

    // check if it's Pi who's sending the data
    if (data == "Its a me, Mario") {
      pi = sock.remoteAddress + ":" + sock.remotePort;
      piSock = sock;
      console.log('pi connected');
      sock.write("0");
    } else if (sock.remoteAddress + ":" + sock.remotePort == pi) {
      const sql = `INSERT INTO readings (humidity,date) VALUES (${data},NOW())`;

      if (data > 75.0) {
        con.query(sql, function (err, result) {
          if (err) throw err;
          console.log("1 record inserted");
        });
        // send a message to Pi to take a photo of your window sill if it reaches certain humidity %
        console.log("take_a_pic");
        sock.write("1");
      } else if (data == 0) {
        sock.write("0");
      } else if (data == "new_photo") {
        console.log("new_photo");
        sock.write("0");
        // let every client know that new photo has been updloaded
        clientSocks.forEach(function (connection, index) {
          if (connection != piSock) {
            connection.write("new_photo_arrived");
          }
        });
      } else {
        con.query(sql, function (err, result) {
          if (err) throw err;
          console.log("1 record inserted");
          sock.write("0");
        });
      }
    } else if (data == 1 && pi != null) {
      // got a request from clients to take a photo
      console.log(`${piSock} take_a_pic  ${sock}`);
      piSock.write("1");
      sock.write("You're not pi!");
    }
  });

  sock.on('close', function () {
    console.log(`${sock.remoteAddress}:${sock.remotePort} Connection closed`);
  });

  // Handle Client connection error.
  sock.on('error', function (error) {
    console.error(`${sock.remoteAddress}:${sock.remotePort} Connection Error ${error}`);
  });
};