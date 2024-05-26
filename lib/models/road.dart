// lib/models/road.dart
import 'vehicle.dart';
import 'accident_type.dart';
import 'weather_condition.dart'; // Bu satırı ekleyin

enum RoadCondition { Good, Fair, Poor }

class Road {
  RoadCondition condition;
  WeatherCondition weather;
  int vehicleCount1;
  int vehicleCount2;
  List<Vehicle> vehicles1;
  List<Vehicle> vehicles2;
  double speedLimit;
  AccidentType accident1; // Güncellenmiş
  AccidentType accident2; // Güncellenmiş
  int laneCount;

  Road({
    required this.condition,
    required this.weather,
    required this.vehicleCount1,
    required this.vehicleCount2,
    required this.vehicles1,
    required this.vehicles2,
    required this.speedLimit,
    required this.accident1,
    required this.accident2,
    required this.laneCount,
  });
}
