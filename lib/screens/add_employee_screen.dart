
import 'package:employee_management/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/employee.dart';
import '../providers/employee_provider.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController positionController = TextEditingController();
    final TextEditingController departmentController = TextEditingController();

    final formKey = GlobalKey<FormState>(); // Form key for validation

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Employee',
          style: TextStyle(color: AppConstants.secondaryColor),
        ),
        leading: IconButton(
          icon: Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0),
              ),
            child: const Icon(Icons.arrow_back_ios)), // Back arrow icon
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        backgroundColor: const Color(0xFF0D47A1), // Dark Blue
        foregroundColor: AppConstants.secondaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1), // Dark Blue
              Color(0xFF1976D2), // Medium-Dark Blue
              Color(0xFF42A5F5), // Medium-Light Blue
              Color(0xFF90CAF9), // Bright Light Blue
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D47A1), // Dark Blue
                  Color(0xFF1976D2), // Medium-Dark Blue
                  Color(0xFF42A5F5), // Medium-Light Blue
                ],
              ),
              borderRadius: BorderRadius.circular(16.0), // Rounded corners for the container
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:25.0,right:25,top:30,bottom:30),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField('Employee ID', idController),
                    _buildTextField('Name', nameController),
                    _buildTextField('Position', positionController),
                    _buildTextField('Department', departmentController),
                    const SizedBox(height: 20),
                    AppConstants.customButton(
                      label: 'Add Employee',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final employeeId = idController.text;
              
                          // Check if the ID already exists
                          bool idExists = await Provider.of<EmployeeProvider>(context, listen: false).isIdExists(employeeId);
              
                          if (idExists) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                 AppConstants.createSnackBar(AppConstants.idIsUsedByAnotherMessage, backgroundColor: Colors.red),
              
                            );
                          } else {
                            final employee = Employee(
                              id: employeeId,
                              name: nameController.text,
                              position: positionController.text,
                              department: departmentController.text,
                            );
              
                            Provider.of<EmployeeProvider>(context, listen: false)
                                .addEmployee(employee)
                                .then((_) {
                              Navigator.pop(context, true); // Return true to indicate employee was added
                              ScaffoldMessenger.of(context).showSnackBar(
                                AppConstants.createSnackBar(AppConstants.addEmployeeSuccessMessage, backgroundColor: Colors.green),
                              );
                            });
                          }
                        }
                      },
                      width: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable TextField with validation
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
