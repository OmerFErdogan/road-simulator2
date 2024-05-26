// lib/widgets/lane_changer.dart
import '../models/road.dart';
import '../models/vehicle.dart';
import '../models/accident_type.dart';

class LaneChanger {
  void changeLanes(Road road) {
    // Eğer şerit 2'de hız azalması varsa bir araç şerit 1'e geçsin
    if (road.vehicles2.isNotEmpty && road.accident2 == AccidentType.None) {
      Vehicle? vehicleToMoveToLane1 = findVehicleToMoveToLane1(road);
      if (vehicleToMoveToLane1 != null) {
        road.vehicles2.remove(vehicleToMoveToLane1);
        vehicleToMoveToLane1.lane = 1;
        road.vehicles1.add(vehicleToMoveToLane1);
      }
    }

    // Eğer şerit 1'de hız azalması varsa bir araç şerit 2'ye geçsin
    if (road.vehicles1.isNotEmpty && road.accident1 == AccidentType.None) {
      Vehicle? vehicleToMoveToLane2 = findVehicleToMoveToLane2(road);
      if (vehicleToMoveToLane2 != null) {
        road.vehicles1.remove(vehicleToMoveToLane2);
        vehicleToMoveToLane2.lane = 2;
        road.vehicles2.add(vehicleToMoveToLane2);
      }
    }

    // Araç sayısını güncelle
    road.vehicleCount1 = road.vehicles1.length;
    road.vehicleCount2 = road.vehicles2.length;
  }

  Vehicle? findVehicleToMoveToLane1(Road road) {
    double averageSpeed2 = calculateAverageSpeed(road.vehicles2);
    if (averageSpeed2 < 50) {
      // Şerit 2'deki araçlar arasında en düşük hızda olanı bul
      Vehicle slowestVehicle = road.vehicles2
          .reduce((curr, next) => curr.speed < next.speed ? curr : next);
      return slowestVehicle;
    }
    return null;
  }

  Vehicle? findVehicleToMoveToLane2(Road road) {
    double averageSpeed1 = calculateAverageSpeed(road.vehicles1);
    if (averageSpeed1 < 50) {
      // Şerit 1'deki araçlar arasında en düşük hızda olanı bul
      Vehicle slowestVehicle = road.vehicles1
          .reduce((curr, next) => curr.speed < next.speed ? curr : next);
      return slowestVehicle;
    }
    return null;
  }

  double calculateAverageSpeed(List<Vehicle> vehicles) {
    if (vehicles.isEmpty) return 0;
    double totalSpeed =
        vehicles.fold(0.0, (sum, vehicle) => sum + vehicle.speed);
    return totalSpeed / vehicles.length;
  }
}
