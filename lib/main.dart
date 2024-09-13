import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/employee_provider.dart';
import 'screens/add_employee_screen.dart';
import 'screens/employee_details_screen.dart';
import 'screens/home_screen.dart';  // Import your HomeScreen
import 'screens/splash_screen.dart'; // Import your SplashScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmployeeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Employee Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(), // Set SplashScreen as the initial screen
        routes: {
          '/home': (context) => const HomeScreen(), // Define route for HomeScreen
          '/add': (context) => const AddEmployeeScreen(),
          '/details': (context) => const EmployeeDetailsScreen(),
          // You can add routes for other screens here
        },
      ),
    );
  }
}
