// lib/models/vehicle.dart
enum VehicleType { Car, Truck }

class Vehicle {
  VehicleType type;
  double speed;
  double position;
  int lane;

  Vehicle(this.type, this.speed, this.position, this.lane);
}
