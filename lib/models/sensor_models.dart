import 'dart:math';

class AccelerometerData {
  final double x;
  final double y;
  final double z;
  final double magnitude;

  AccelerometerData(this.x, this.y, this.z)
      : magnitude = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));

  /// Determines if significant movement is detected
  bool get isMoving => magnitude > 1.2;

  /// Formats values for display
  String get formattedValue => 'X: ${x.toStringAsFixed(2)}\n'
      'Y: ${y.toStringAsFixed(2)}\n'
      'Z: ${z.toStringAsFixed(2)}';
}

/// Model for weather data from API
class WeatherData {
  final double temperature;
  final double humidity;
  final DateTime lastUpdated;

  WeatherData({
    required this.temperature,
    required this.humidity,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
    );
  }
}

/// Model for gas concentration readings
class GasData {
  final double coPpm; // Carbon Monoxide in parts-per-million
  final double methaneLEL; // Methane as % of Lower Explosive Limit
  final DateTime timestamp;

  GasData({
    required this.coPpm,
    required this.methaneLEL,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Returns danger level (0-1) based on safety thresholds
  double get dangerLevel {
    final coDanger = min(coPpm / 50, 1.0); // 50ppm = danger threshold
    final methaneDanger = min(methaneLEL / 5, 1.0); // 5% LEL = danger threshold
    return max(coDanger, methaneDanger);
  }
}

/// Combined model for all sensor readings
class MineSensorData {
  final AccelerometerData? accelerometer;
  final WeatherData? weather;
  final GasData gas;
  final bool isVibrating;
  final DateTime timestamp;

  MineSensorData({
    required this.accelerometer,
    required this.weather,
    required this.gas,
    required this.isVibrating,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Overall safety score (0-10)
  int get safetyScore {
    var score = 8.0; // Base score

    // Deductions for hazards
    if (gas.dangerLevel > 0.3) score -= 3;
    if (isVibrating) score -= 2;
    if (accelerometer?.isMoving == true) score -= 1;

    return score.clamp(0, 10).round();
  }
}
