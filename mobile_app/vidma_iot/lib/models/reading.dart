import 'package:flutter/material.dart';

class Reading with ChangeNotifier {
  int id;
  double humidity;
  DateTime date;

  Reading({
    required this.id,
    required this.humidity,
    required this.date,
  });

  factory Reading.fromJson(Map<String, dynamic> json) {
    return Reading(
      id: json['id'],
      humidity: json['humidity'],
      date: DateTime.parse(json['date']),
    );
  }
}
