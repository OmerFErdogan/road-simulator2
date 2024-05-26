// lib/utils/accident_calculator.dart
import 'dart:math';
import '../models/accident_type.dart';
import '../models/road.dart';
import '../models/weather_condition.dart';

final Random random = Random();

AccidentType calculateAccident(double congestion, WeatherCondition weather,
    RoadCondition roadCondition, int vehicleCount) {
  double chance = random.nextDouble();

  // Base probabilities
  double minorProbability = 0.02;
  double majorProbability = 0.01;
  double severeProbability = 0.005;

  // Adjust probabilities based on weather condition
  switch (weather) {
    case WeatherCondition.Sisli:
      minorProbability *= 1.5;
      majorProbability *= 2;
      severeProbability *= 2.5;
      break;
    case WeatherCondition.Yagmurlu:
      minorProbability *= 2;
      majorProbability *= 2.5;
      severeProbability *= 3;
      break;
    case WeatherCondition.Normal:
    default:
      // No change for sunny or default weather
      break;
  }

  // Adjust probabilities based on road condition
  switch (roadCondition) {
    case RoadCondition.Poor:
      minorProbability *= 1.5;
      majorProbability *= 2;
      severeProbability *= 2.5;
      break;
    case RoadCondition.Good:
    default:
      // No change for good or default road condition
      break;
  }

  // Adjust probabilities based on vehicle count (higher vehicle count increases probability)
  if (vehicleCount > 15) {
    minorProbability *= 1.5;
    majorProbability *= 2;
    severeProbability *= 2.5;
  } else if (vehicleCount > 10) {
    minorProbability *= 1.2;
    majorProbability *= 1.5;
    severeProbability *= 1.8;
  }

  // Final probability calculation
  if (congestion > 50) {
    if (chance < severeProbability) return AccidentType.Severe;
    if (chance < majorProbability) return AccidentType.Major;
    if (chance < minorProbability) return AccidentType.Minor;
  } else if (congestion > 30) {
    if (chance < majorProbability) return AccidentType.Major;
    if (chance < minorProbability) return AccidentType.Minor;
  } else {
    if (chance < minorProbability) return AccidentType.Minor;
  }

  return AccidentType.None;
}

double getAccidentImpact(AccidentType type) {
  switch (type) {
    case AccidentType.Minor:
      return 0.9; // 10% speed reduction
    case AccidentType.Major:
      return 0.6; // 40% speed reduction
    case AccidentType.Severe:
      return 0.3; // 70% speed reduction
    default:
      return 1.0; // No impact
  }
}
