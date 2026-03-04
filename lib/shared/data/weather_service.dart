import 'dart:math' as math;

/// Mock weather service that produces realistic fluctuating values.
/// Uses time-based sinusoidal variation to simulate Chennai-like climate.
/// Production-ready hooks for OpenWeatherMap integration via AWS Lambda backend.
class WeatherService {
  WeatherService._();

  /// Returns current mock temperature for Chennai (~30°C + sin variation).
  static double getCurrentTemperature() {
    final now = DateTime.now();
    final hourFraction = now.hour + now.minute / 60.0 + now.second / 3600.0;

    // Base temp varies through the day: cooler at night, hotter at 2 PM
    final diurnalPhase = (hourFraction - 14) / 24 * 2 * math.pi;
    final baseTemp = 30.0 + 4.0 * math.cos(diurnalPhase);

    // Small random-ish component from seconds
    final microVar = math.sin(now.millisecondsSinceEpoch / 10000.0) * 0.8;

    return baseTemp + microVar;
  }

  /// Returns current mock humidity for Chennai (~70% ± variation).
  static double getCurrentHumidity() {
    final now = DateTime.now();
    final hourFraction = now.hour + now.minute / 60.0 + now.second / 3600.0;

    // Humidity inverse of temp: higher at night, lower at noon
    final diurnalPhase = (hourFraction - 14) / 24 * 2 * math.pi;
    final baseHumidity = 68.0 - 8.0 * math.cos(diurnalPhase);

    final microVar = math.cos(now.millisecondsSinceEpoch / 12000.0) * 2.0;

    return (baseHumidity + microVar).clamp(40.0, 95.0);
  }

  /// Returns city name for display.
  static String getCityName() => 'Chennai';
}
