import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tcp_socket_connection/tcp_socket_connection.dart';
import 'models/reading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String message = "";
  // Change this to your TCP server
  TcpSocketConnection socketConnection = TcpSocketConnection("vimo.lt", 25999);

  // Receiving and sending back a custom message
  void messageReceived(String msg) {
    setState(() {
      message = msg;
    });
    // socketConnection.sendMessage("Message received from SERVER");
  }

  // void startConnection() async {
  //   socketConnection.enableConsolePrint(
  //       true); //use this to see in the console what's happening
  //   if (await socketConnection.canConnect(5000, attempts: 3)) {
  //     //check if it's possible to connect to the endpoint
  //     await socketConnection.connect(5000, messageReceived, attempts: 3);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // startConnection();
  }

  void piTakePhoto() {
    socketConnection.connect(5000, messageReceived);
    socketConnection.sendMessage(1.toString());
    socketConnection.disconnect();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
    socketConnection.connect(5000, messageReceived);
    socketConnection.sendMessage(_counter.toString());
    socketConnection.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            return Container(
              child: ReadingsList(readings: snapshot.data!),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
      backgroundColor: Color.fromARGB(255, 254, 255, 184),
      floatingActionButton: FloatingActionButton(
        onPressed: piTakePhoto,
        child: const Icon(Icons.camera_alt),
      ),

      // Center(
      //   // Center is a layout widget. It takes a single child and positions it
      //   // in the middle of the parent.
      //   child: Column(
      //     // Column is also a layout widget. It takes a list of children and
      //     // arranges them vertically. By default, it sizes itself to fit its
      //     // children horizontally, and tries to be as tall as its parent.
      //     //
      //     // Invoke "debug painting" (press "p" in the console, choose the
      //     // "Toggle Debug Paint" action from the Flutter Inspector in Android
      //     // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
      //     // to see the wireframe for each widget.
      //     //
      //     // Column has various properties to control how it sizes itself and
      //     // how it positions its children. Here we use mainAxisAlignment to
      //     // center the children vertically; the main axis here is the vertical
      //     // axis because Columns are vertical (the cross axis would be
      //     // horizontal).
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headline4,
      //       ),
      //       Text(
      //         'You have received ' + message,
      //       ),
      //       FloatingActionButton(onPressed: piTakePhoto)
      //     ],
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ReadingsList extends StatelessWidget {
  const ReadingsList({super.key, required this.readings});

  final List<Reading> readings;

  @override
  Widget build(BuildContext context) {
    // return GridView.builder(
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     childAspectRatio: 4,
    //   ),
    //   itemCount: readings.length,
    //   itemBuilder: (context, index) {
    //     return Column(
    //       children: [
    //         Text(
    //           readings[index].humidity.toString(),
    //           style: const TextStyle(
    //             fontSize: 16,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         Text(DateFormat('yy-MM-dd hh:mm:ss').format(readings[index].date))
    //       ],
    //     );
    //     // return Image.network("http://vimo.lt/images/vimo512x194.png");
    //     // return Image.network(readings[index].thumbnailUrl);
    //   },
    // );
    return SizedBox(
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
          readings.length,
          (int index) => DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              // All rows will have the same selected color.
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }
              // Even rows will have a grey color.
              if (index.isEven) {
                return Colors.grey.withOpacity(0.3);
              }
              return null; // Use default value for other states and odd rows.
            }),
            cells: <DataCell>[
              DataCell(Text(readings[index].humidity.toString())),
              DataCell(Text(
                  DateFormat('yy-MM-dd hh:mm:ss').format(readings[index].date)))
            ],
          ),
        ),
      ),
    );
  }
}
