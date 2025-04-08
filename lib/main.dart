import 'package:coal_monitor/provider/permission_provider.dart';
import 'package:coal_monitor/provider/sensor_provider.dart';
import 'package:coal_monitor/screens/home_screen.dart';
import 'package:coal_monitor/screens/setup_screen.dart';
import 'package:coal_monitor/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PermissionProvider>(
            create: (_) => PermissionProvider()),
        ChangeNotifierProvider<SensorProvider>(create: (_) => SensorProvider()),
      ],
      child: MaterialApp(
        title: 'Coal Monitor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/home': (_) => const HomeScreen(),
          '/setup': (_) => const SetupScreen(),
        },
      ),
    );
  }
}
