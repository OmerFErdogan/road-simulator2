// lib/utils/vehicle_manager.dart
import '../models/vehicle.dart';
import '../models/road.dart';
import 'congestion_calculator.dart';
import 'speed_calculator.dart';
import 'accident_calculator.dart';

class VehicleManager {
  static void updateVehicleSpeeds(
      Road road, bool isLane1Usable, bool isLane2Usable) {
    double congestion1 =
        calculateCongestion(road.vehicleCount1, road.laneCount);
    double congestion2 =
        calculateCongestion(road.vehicleCount2, road.laneCount);

    double accidentImpact1 = getAccidentImpact(road.accident1);
    double accidentImpact2 = getAccidentImpact(road.accident2);

    road.vehicles1.forEach((vehicle) {
      vehicle.speed = calculateSpeed(
            road.speedLimit.toDouble(),
            congestion1,
            road.weather,
            road.condition,
            vehicle.type,
          ) *
          (isLane1Usable ? accidentImpact1 : 0);
    });

    road.vehicles2.forEach((vehicle) {
      vehicle.speed = calculateSpeed(
            80.0, // Base speed for trucks
            congestion2,
            road.weather,
            road.condition,
            vehicle.type,
          ) *
          (isLane2Usable ? accidentImpact2 : 0);
    });
  }

  static double calculateAverageSpeed(List<Vehicle> vehicles) {
    if (vehicles.isEmpty) return 0.0;
    double totalSpeed =
        vehicles.fold(0.0, (sum, vehicle) => sum + vehicle.speed);
    return totalSpeed / vehicles.length;
  }

  static void updateVehiclePositions(Road road) {
    List<Vehicle> allVehicles = [...road.vehicles1, ...road.vehicles2];
    allVehicles.sort((a, b) => a.position.compareTo(b.position));

    for (var vehicle in allVehicles) {
      double previousPosition = vehicle.position;
      vehicle.position += vehicle.speed /
          3600 /
          20; // Update position based on speed and time (smoother animation)
      if (vehicle.position > 1) vehicle.position = 0; // Loop position

      if (isColliding(vehicle, allVehicles)) {
        vehicle.position = previousPosition;
      }
    }
  }

  static bool isColliding(Vehicle vehicle, List<Vehicle> allVehicles) {
    for (var otherVehicle in allVehicles) {
      if (otherVehicle != vehicle && otherVehicle.lane == vehicle.lane) {
        if ((vehicle.position - otherVehicle.position).abs() < 0.05) {
          // Check for collision within a certain range
          return true;
        }
      }
    }
    return false;
  }
}
