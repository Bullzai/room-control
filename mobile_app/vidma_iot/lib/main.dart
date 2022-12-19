import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'models/reading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

var counter = 0;

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

List<Reading> parseReadings(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Reading>((json) => Reading.fromJson(json)).toList();
}

Future<List<Reading>> fetchReadings() async {
  final response =
      // Change this to your API readings
      await http.get(Uri.parse('http://vimo.lt:25998/api/readings/latest10'));
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

  Image img = Image.network("http://vimo.lt/images/iot/frame1.jpg");
  // Change this to your TCP server
  TcpSocketConnection socketConnection = TcpSocketConnection("vimo.lt", 25999);

  // Receiving and sending back a custom message
  void messageReceived(String msg) {
    setState(() {
      message = msg;
    });
    // socketConnection.sendMessage("Message received from SERVER");
  }

  void startConnection() async {
    socketConnection.enableConsolePrint(
        true); //use this to see in the console what's happening
    if (await socketConnection.canConnect(5000, attempts: 3)) {
      //check if it's possible to connect to the endpoint
      await socketConnection.connect(5000, messageReceived, attempts: 3);
    }
  }

  @override
  void initState() {
    super.initState();
    startConnection();
  }

  void piTakePhoto() {
    // setState(() {
    //   // This call to setState tells the Flutter framework that something has
    //   // changed in this State, which causes it to rerun the build method below
    //   // so that the display can reflect the updated values.

    //   // imageCache.clear();
    //   // imageCache.clearLiveImages();
    // });
    socketConnection.connect(5000, messageReceived);
    socketConnection.sendMessage(1.toString());
    socketConnection.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the piTakePhoto method above.
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
            // update the tables & photo
            if (imageCache.liveImageCount > 0) {
              imageCache.clear();
              imageCache.clearLiveImages();
            }
            // imageCache.clear();
            // imageCache.clearLiveImages();
            counter++;
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

class ReadingsList extends StatelessWidget {
  const ReadingsList({super.key, required this.readings});

  final List<Reading> readings;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('Humidity'),
            ),
            DataColumn(
              label: Text('Date'),
            ),
          ],
          rows: List<DataRow>.generate(
            // Number of rows to be displayed
            readings.length - 5,
            (int index) => DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                // All rows will have the same selected color.
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.08);
                }
                // Even rows will have a grey color.
                if (index.isEven) {
                  return Colors.grey.withOpacity(0.3);
                }
                return null; // Use default value for other states and odd rows.
              }),
              cells: <DataCell>[
                DataCell(Text(readings[index].humidity.toString())),
                DataCell(Text(DateFormat('yy-MM-dd hh:mm:ss')
                    .format(readings[index].date)))
              ],
            ),
          ),
        ),
      ),
//       FutureBuilder(
//         // Paste your image URL inside the htt.get method as a parameter
//         future: http.get(Uri.parse("http://vimo.lt/images/iot/frame1.jpg")),
//         builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.none:
//               return Text('Press button to start.');
//             case ConnectionState.active:
//             case ConnectionState.waiting:
//               return CircularProgressIndicator();
//             case ConnectionState.done:
//               if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//               // when we get the data from the http call, we give the bodyBytes to Image.memory for showing the image
//               return Image.memory(snapshot.data!.bodyBytes);
//           }
// // unreachable
//         },
//       ), // Image(
      //     image: CachedNetworkImageProvider(
      //         "http://vimo.lt/images/iot/frame1.jpg")),
      Image.network(
        "http://vimo.lt/images/iot/frame1.jpg",
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        key: ValueKey(new Random().nextInt(100)),
      ),
      // Image(
      //   image: NetworkImage("http://vimo.lt/images/iot/frame1.jpg"),
      //   key: ValueKey(new Random().nextInt(100)),
      // )
      // Image.network("http://vimo.lt/images/iot/frame1.jpg" +
      //     "?v=${DateTime.now().millisecondsSinceEpoch}"),
    ]);
  }
}
