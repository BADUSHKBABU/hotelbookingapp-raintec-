import 'package:flutter/material.dart';
import 'screens/dashboard_shell.dart';
import 'core/theme.dart';

void main() {
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  final int initialTabIndex;

  const HotelBookingApp({super.key, this.initialTabIndex = 1});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raintech Hotel Management & Booking',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: DashboardShell(initialTabIndex: initialTabIndex),
    );
  }
}
