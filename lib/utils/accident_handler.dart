// lib/utils/accident_handler.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/road.dart';
import '../models/accident_type.dart' as accident_model;

class AccidentHandler {
  static void handleAccident(
      BuildContext context,
      int laneNumber,
      accident_model.AccidentType accidentType,
      Road road,
      List<double> originalSpeedsLane1,
      List<double> originalSpeedsLane2,
      Function updateSimulation) {
    if (accidentType != accident_model.AccidentType.None) {
      int duration = 0;
      String message = '';
      switch (accidentType) {
        case accident_model.AccidentType.Minor:
          duration = 2;
          message = 'Şerit $laneNumber\'de küçük bir kaza';
          break;
        case accident_model.AccidentType.Major:
          duration = 5;
          message = 'Şerit $laneNumber\'de büyük bir kaza';
          break;
        case accident_model.AccidentType.Severe:
          duration = 8;
          message = 'Şerit $laneNumber\'de ciddi bir kaza';
          break;
        default:
          break;
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );

      if (laneNumber == 1) {
        if (accidentType == accident_model.AccidentType.Severe) {
          originalSpeedsLane1.clear();
          road.vehicles1.forEach((vehicle) {
            originalSpeedsLane1.add(vehicle.speed);
            vehicle.lane = 2;
            road.vehicles2.add(vehicle);
          });
          road.vehicles1.clear();
          Future.delayed(Duration(seconds: duration), () {
            for (int i = 0; i < road.vehicles1.length; i++) {
              road.vehicles1[i].speed = originalSpeedsLane1[i];
            }
            road.accident1 = accident_model.AccidentType.None;
            updateSimulation();
          });
        } else {
          originalSpeedsLane1.clear();
          road.vehicles1.forEach((vehicle) {
            originalSpeedsLane1.add(vehicle.speed);
            vehicle.speed = 0;
          });
          Future.delayed(Duration(seconds: duration), () {
            for (int i = 0; i < road.vehicles1.length; i++) {
              road.vehicles1[i].speed = originalSpeedsLane1[i];
            }
            road.accident1 = accident_model.AccidentType.None;
            updateSimulation();
          });
        }
      } else {
        if (accidentType == accident_model.AccidentType.Severe) {
          originalSpeedsLane2.clear();
          road.vehicles2.forEach((vehicle) {
            originalSpeedsLane2.add(vehicle.speed);
            vehicle.lane = 1;
            road.vehicles1.add(vehicle);
          });
          road.vehicles2.clear();
          Future.delayed(Duration(seconds: duration), () {
            for (int i = 0; i < road.vehicles2.length; i++) {
              road.vehicles2[i].speed = originalSpeedsLane2[i];
            }
            road.accident2 = accident_model.AccidentType.None;
            updateSimulation();
          });
        } else {
          originalSpeedsLane2.clear();
          road.vehicles2.forEach((vehicle) {
            originalSpeedsLane2.add(vehicle.speed);
            vehicle.speed = 0;
          });
          Future.delayed(Duration(seconds: duration), () {
            for (int i = 0; i < road.vehicles2.length; i++) {
              road.vehicles2[i].speed = originalSpeedsLane2[i];
            }
            road.accident2 = accident_model.AccidentType.None;
            updateSimulation();
          });
        }
      }
    }
  }
}
