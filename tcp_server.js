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
// Keep track of the chat clients
// let clients = [];

server.listen(port, function () {
  console.log(`Server started on port ${port}`);
});

function onClientConnection(sock) {
  console.log(`${sock.remoteAddress}:${sock.remotePort} Connected`);
  // Put this new client in the list
  // clients.push(sock);
  //Handle the client data.
  sock.on('data', function (data) {
    //Log data received from the client
    console.log(`>> data received : ${data} `);

    if (data == "Its a me, Mario") {
      pi = sock.remoteAddress + ":" + sock.remotePort;
      piSock = sock;
      console.log('pi connected');
      sock.write("0");
    } else if (sock.remoteAddress + ":" + sock.remotePort == pi) {
      const sql = `INSERT INTO readings (humidity,date) VALUES (${data},NOW())`;

      if (data > 83.0) {
        con.query(sql, function (err, result) {
          if (err) throw err;
          console.log("1 record inserted");
        });
        console.log("take_a_pic");
        sock.write("1");
        // sock.end();
      } else if (data == 0) {
        sock.write("0");
      } else {
        con.query(sql, function (err, result) {
          if (err) throw err;
          console.log("1 record inserted");
          sock.write("0");
        });
      }
    } else if (data == 1 && pi != null) {
      console.log(`${piSock} take_a_pic  ${sock}`);
      piSock.write("1");
      sock.write("Not a PIIII");
    }

    //close the connection 
    // sock.end();
  });

  // // Remove the client from the list when it leaves
  // sock.on('end', function () {
  //   clients.splice(clients.indexOf(socket), 1);
  //   broadcast(sock.name + " disconnected.\n");
  // });
  //Handle when client connection is closed
  sock.on('close', function () {
    console.log(`${sock.remoteAddress}:${sock.remotePort} Connection closed`);
  });

  //Handle Client connection error.
  sock.on('error', function (error) {
    console.error(`${sock.remoteAddress}:${sock.remotePort} Connection Error ${error}`);
  });
};