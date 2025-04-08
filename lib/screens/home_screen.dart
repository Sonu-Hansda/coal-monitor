import 'package:coal_monitor/provider/sensor_provider.dart';
import 'package:coal_monitor/widgets/health_bar.dart';
import 'package:coal_monitor/widgets/sensor_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mine Safety Dashboard'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              HealthBar(
                healthLevel: sensorProvider.calculateMineHealth(),
              ),
              const SizedBox(height: 20),

              // Sensor Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  // Temperature
                  SensorCard(
                    title: "Temperature",
                    value: sensorProvider.weatherData?.temperature
                            .toStringAsFixed(1) ??
                        "N/A",
                    unit: "°C",
                    icon: Icons.thermostat,
                    color: Colors.red,
                  ),

                  // Humidity
                  SensorCard(
                    title: "Humidity",
                    value: sensorProvider.weatherData?.humidity
                            .toStringAsFixed(1) ??
                        "N/A",
                    unit: "%",
                    icon: Icons.water_drop,
                    color: Colors.blue,
                  ),

                  // Vibration
                  SensorCard(
                    title: "Vibration",
                    value: sensorProvider.isVibrating ? "Yes" : "No",
                    unit: "",
                    icon: Icons.vibration,
                    color: Colors.purple,
                  ),

                  // Gas (CO)
                  SensorCard(
                    title: "Carbon Monoxide",
                    value: sensorProvider.gasData.coPpm.toStringAsFixed(1),
                    unit: "ppm",
                    icon: Icons.cloud,
                    color: Colors.brown,
                  ),

                  // Gas (Methane)
                  SensorCard(
                    title: "Methane",
                    value: sensorProvider.gasData.methaneLEL.toStringAsFixed(1),
                    unit: "% LEL",
                    icon: Icons.cloud,
                    color: Colors.green,
                  ),

                  // Accelerometer
                  SensorCard(
                    title: "Accelerometer",
                    value: sensorProvider.accelerometerData?.isMoving == true
                        ? "Moving"
                        : "Stable",
                    unit: "",
                    icon: Icons.rotate_90_degrees_ccw,
                    color: Colors.indigo,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
