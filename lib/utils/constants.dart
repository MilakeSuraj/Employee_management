
import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Colors.blueGrey;
  static const Color secondaryColor = Colors.white;
  static const Color errorColor = Colors.red;

  // Text Styles
  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.black54,
  );

  // Snackbar Messages
  static const String addEmployeeSuccessMessage = 'Employee added successfully!';
  static const String updateEmployeeSuccessMessage = 'Employee updated successfully!';
  static const String deleteEmployeeSuccessMessage = 'Employee deleted successfully!';
  static const String idIsUsedByAnotherMessage = 'This ID is used by another employee please select another ID.';

  static const String errorMessage = 'An error occurred. Please try again.';

  // SnackBar Helpers
  static SnackBar createSnackBar(String message, {Color backgroundColor = Colors.black}) {
    return SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
    );
  }

  // Reusable Button
  static Widget customButton({
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = const Color.fromARGB(255, 15, 30, 233),


    double? width, // Optional width
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),  // Keep button consistent with HomeScreen
          ),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white),  ),
      ),
    );
  }
}
