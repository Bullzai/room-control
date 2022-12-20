import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'package:http/http.dart' as http;
import 'models/reading.dart';
import 'widgets/readings_list.dart';

List<Reading> parseReadings(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Reading>((json) => Reading.fromJson(json)).toList();
}

Future<List<Reading>> fetchReadings() async {
  final response =
      // Change this to your API readings.
      await http.get(Uri.parse('http://vimo.lt:25998/api/readings/latest5'));
  if (response.statusCode == 200) {
    return parseReadings(response.body);
  } else {
    throw Exception('Failed to load readings');
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of application.
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Humidity readings'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String message = "";
  // Change this to your photo URL.
  Image img = Image.network("http://vimo.lt/images/iot/frame1.jpg");
  // Change this to your TCP server.
  TcpSocketConnection socketConnection = TcpSocketConnection("vimo.lt", 25999);

  // Receiving and sending back a custom message.
  void messageReceived(String msg) {
    // This call to setState tells the Flutter framework that something has
    // changed in this State, which causes it to rerun the build method below
    // so that the display can reflect the updated values.
    setState(() {
      message = msg;
    });
  }

  void startConnection() async {
    socketConnection.enableConsolePrint(
        true); // Use this to see in the console what's happening.
    if (await socketConnection.canConnect(5000, attempts: 3)) {
      // Check if it's possible to connect to the endpoint.
      await socketConnection.connect(5000, messageReceived, attempts: 3);
    }
  }

  @override
  void initState() {
    super.initState();
    startConnection();
  }

  // Sends a message to TCP server, which will then in turn tell Rasberry Pi to take a photo.
  void piTakePhoto() {
    socketConnection.connect(5000, messageReceived);
    socketConnection.sendMessage(1.toString());
    socketConnection.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done by the piTakePhoto method above.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Reading>>(
        future: fetchReadings(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occured!'),
            );
          } else if (snapshot.hasData) {
            return ReadingsList(readings: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
      backgroundColor: Color.fromARGB(255, 254, 255, 184),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            // Prevent app crash by checking if there's any cached images and if
            // TCP server has already sent a message that a new photo has been uploaded.
            if (imageCache.liveImageCount > 0 &&
                message == "new_photo_arrived") {
              imageCache.clear();
              imageCache.clearLiveImages();
              message = "";
            }
            // Set State to force a rerun of build method (update screen in other words).
            setState(() {});
          },
          heroTag: null,
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () => piTakePhoto(),
          heroTag: null,
        )
      ]),
    );
  }
}
