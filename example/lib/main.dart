import 'dart:async';

import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _batteryIndicatorPlugin = BatteryIndicator();
  var value = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Listener(
          child: StreamBuilder<int>(
            stream: _batteryIndicatorPlugin.getBatteryLevelStream(),
            initialData: 0,
            builder: (context, snapshot) {
              final newValue = snapshot.data;
              if (newValue != null) {
                if (value > newValue) {
                  Future.microtask(
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('ВНИМАНИЕ: Аккумулятор просел')),
                    ),
                  );
                }
                value = newValue;
              }

              return Center(
                child: Text("Battery value $newValue%"),
              );
            },
          ),
        ),
      ),
    );
  }
}
