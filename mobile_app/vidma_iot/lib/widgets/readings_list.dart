import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reading.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

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
            readings.length,
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
        // An extra layer to prevent app from crashing on trying to load an image that is still being uploaded.
        key: ValueKey(new Random().nextInt(1000)),
      ),
    ]);
  }
}
