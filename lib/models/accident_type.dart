// lib/models/accident_type.dart
enum AccidentType {
  None,
  Minor,
  Major,
  Severe,
}

String getAccidentDescription(AccidentType type) {
  switch (type) {
    case AccidentType.None:
      return "No Accident";
    case AccidentType.Minor:
      return "Minor Accident";
    case AccidentType.Major:
      return "Major Accident";
    case AccidentType.Severe:
      return "Severe Accident";
    default:
      return "Unknown";
  }
}
