// lib/utils/congestion_calculator.dart
double calculateCongestion(int vehicleCount, int laneCount) {
  double congestion = (vehicleCount / (laneCount * 10)) * 100; // Max 100%
  return congestion > 100
      ? 100
      : congestion; // Ensure congestion does not exceed 100%
}
