import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/sensor_models.dart';

class SensorProvider with ChangeNotifier {
  AccelerometerData? _accelerometerData;
  WeatherData? _weatherData;
  GasData _gasData = GasData(coPpm: 0, methaneLEL: 0);
  bool _isVibrating = false;
  bool _isLoading = false;

  // Getters
  AccelerometerData? get accelerometerData => _accelerometerData;
  WeatherData? get weatherData => _weatherData;
  GasData get gasData => _gasData;
  bool get isVibrating => _isVibrating;
  bool get isLoading => _isLoading;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  SensorProvider() {
    _initSensors();
    _fetchWeather();
    _startMockGasData();
  }

  Future<void> _initSensors() async {
    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      _accelerometerData = AccelerometerData(event.x, event.y, event.z);

      _checkForVibration();

      notifyListeners();
    });
  }

  void _checkForVibration() {
    if (_accelerometerData == null) return;

    const double vibrationThreshold = 1.5;

    if (_accelerometerData!.magnitude > vibrationThreshold) {
      if (!_isVibrating) {
        _isVibrating = true;
        notifyListeners();
      }
    } else {
      if (_isVibrating) {
        _isVibrating = false;
        notifyListeners();
      }
    }
  }

  Future<void> _fetchWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      final position = await Geolocator.getCurrentPosition();
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=79256dff9fb353cba15f68cc60ada31e'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _weatherData = WeatherData(
          temperature: data['main']['temp'].toDouble(),
          humidity: data['main']['humidity'].toDouble(),
        );
      }
    } catch (e) {
      debugPrint('Weather API Error: $e');
      _weatherData = WeatherData(temperature: 25.0, humidity: 60.0);
    }

    _isLoading = false;
    notifyListeners();
  }

  void _startMockGasData() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _gasData = GasData(
        coPpm: Random().nextDouble() * 20,
        methaneLEL: Random().nextDouble() * 5,
      );
      notifyListeners();
    });
  }

  int calculateMineHealth() {
    double healthScore = 10.0; // Start with a perfect score

    // Deduct points for dangerous gas levels
    if (_gasData.dangerLevel > 0.3) {
      healthScore -= 4; // Significant deduction for high gas danger
    } else if (_gasData.dangerLevel > 0.1) {
      healthScore -= 2; // Moderate deduction for moderate gas danger
    }

    // Deduct points for high temperature
    final temperature = _weatherData?.temperature ?? 25.0;
    if (temperature > 35) {
      healthScore -= 3; // High temperature is dangerous
    } else if (temperature > 30) {
      healthScore -= 1; // Moderate temperature deduction
    }

    // Deduct points for high humidity
    final humidity = _weatherData?.humidity ?? 60.0;
    if (humidity > 80) {
      healthScore -= 2; // High humidity can indicate unsafe conditions
    }

    // Deduct points for vibration
    if (_isVibrating) {
      healthScore -= 2; // Vibration indicates instability
    }

    // Deduct points for significant movement (accelerometer)
    if (_accelerometerData?.isMoving == true) {
      healthScore -= 1; // Movement might indicate instability
    }

    // Ensure the score stays within the range [0, 10]
    return healthScore.clamp(0, 10).toInt();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}
