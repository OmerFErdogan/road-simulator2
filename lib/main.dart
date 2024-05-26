// lib/main.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'pages/road_simulation_page.dart';

void main() {
  runApp(RoadSimulationApp());
}

class RoadSimulationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Road Simulation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: FToastBuilder(),
      home: RoadSimulationPage(),
      //navigatorKey: navigatorKey,
    );
  }
}
