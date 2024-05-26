// lib/models/weather_condition.dart
enum WeatherCondition {
  Normal,
  Yagmurlu,
  Sisli,
}

String getWeatherDescription(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.Normal:
      return "Sunny";
    case WeatherCondition.Yagmurlu:
      return "Rainy";
    case WeatherCondition.Sisli:
      return "Snowy";
    default:
      return "Unknown";
  }
}
