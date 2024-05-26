// lib/utils/speed_calculator.dart
import '../models/road.dart';
import '../models/vehicle.dart';
import '../models/weather_condition.dart';

double calculateSpeed(
    double baseSpeed,
    double congestion,
    WeatherCondition weather,
    RoadCondition roadCondition,
    VehicleType vehicleType) {
  double speed = baseSpeed;

  // Congestion impact
  speed -= (congestion / 100) *
      baseSpeed *
      0.8; // Congestion can reduce speed up to 80%

  // Weather impact
  switch (weather) {
    case WeatherCondition.Sisli:
      speed *= 0.95; // Rain reduces speed by 15%
      break;
    case WeatherCondition.Yagmurlu:
      speed *= 0.90; // Snow reduces speed by 10%
      break;
    default:
      break;
  }

  // Road condition impact
  switch (roadCondition) {
    case RoadCondition.Fair:
      speed *= 0.9; // Fair road condition reduces speed by 10%
      break;
    case RoadCondition.Poor:
      speed *= 0.75; // Poor road condition reduces speed by 25%
      break;
    default:
      break;
  }

  // Vehicle type impact
  if (vehicleType == VehicleType.Truck) {
    speed *= 0.8; // Trucks are generally slower, reducing speed by 20%
  }

  return speed > 5
      ? speed
      : 5; // Ensure speed does not go below a minimum threshold
}
