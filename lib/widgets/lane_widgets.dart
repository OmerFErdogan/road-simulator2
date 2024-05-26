// lib/widgets/lane_widget.dart
import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class LaneWidget extends StatelessWidget {
  final List<Vehicle> vehicles;
  final int laneNumber;

  LaneWidget({required this.vehicles, required this.laneNumber});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: laneNumber * 100.0,
      left: 0,
      right: 0,
      child: Container(
        height: 50,
        color: laneNumber % 2 == 0 ? Colors.grey[300] : Colors.grey[400],
        child: Stack(
          children: vehicles.map((vehicle) {
            return AnimatedPositioned(
              duration: Duration(milliseconds: 50),
              left: vehicle.position * MediaQuery.of(context).size.width,
              child: getVehicleIcon(vehicle.type),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget getVehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.Car:
        return Icon(
          Icons.directions_car_filled_outlined,
          size: 24,
        );

      case VehicleType.Truck:
        return Icon(
          Icons.fire_truck_outlined,
          size: 24,
          color: Colors.blue,
        );
      default:
        return Icon(
          Icons.directions_car,
          size: 24,
          color: type == VehicleType.Car ? Colors.blue : Colors.green,
        );
    }
  }
}
