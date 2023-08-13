import 'package:app_map/screen/launch_screen.dart';
import 'package:app_map/screen/map_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/map_screen',
      routes: {
        '/launch_screen': (context) => const LaunchScreen(),
        '/map_screen': (context) => const MapScreen(),
      },
    );
  }
}
