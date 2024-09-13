import 'package:employee_management/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/employee.dart';
import '../providers/employee_provider.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key});

  @override
  _EmployeeDetailsScreenState createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  late Employee _employee;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _employee = ModalRoute.of(context)!.settings.arguments as Employee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Details',
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
      body: Stack(
        children: [
          // Gradient background
          SizedBox.expand(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D47A1), // Dark Blue
                    Color(0xFF1976D2), // Medium-Dark Blue
                    Color(0xFF42A5F5), // Medium-Light Blue
                    Color(0xFF90CAF9), // Bright Light Blue
                  ],
                ),
              ),
            ),
          ),
          // Your existing content
          SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600), // Limit the container width
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
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Consumer<EmployeeProvider>(
                  builder: (context, employeeProvider, child) {
                    if (employeeProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
            
                    final employee = employeeProvider.employees.firstWhere(
                      (e) => e.id == _employee.id,
                      orElse: () => _employee,
                    );
            
                    return Column(
                      mainAxisSize: MainAxisSize.min, // Make the Column take only the needed height
                      children: [
                        ListView(
                          shrinkWrap: true, // Ensure ListView only takes the space needed
                          physics: const NeverScrollableScrollPhysics(), // Disable scrolling to fit within the container
                          children: [
                            _buildDetailCard('ID', employee.id),
                            _buildDetailCard('Name', employee.name),
                            _buildDetailCard('Position', employee.position),
                            _buildDetailCard('Department', employee.department),
                            const SizedBox(height: 35),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppConstants.customButton(
                              label: 'Edit',
                              onPressed: () {
                                _fetchUpdatedEmployee(context, _employee.id);
                                _showEditDialog(context);
                              },
                              width: 120,
                            ),
                            AppConstants.customButton(
                              label: 'Delete',
                              onPressed: () {
                                _deleteEmployee(context, employee.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  AppConstants.createSnackBar(
                                    AppConstants.deleteEmployeeSuccessMessage,
                                    backgroundColor: AppConstants.errorColor,
                                  ),
                                );
                              },
                              width: 120,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Card(
      color: const Color.fromARGB(255, 15, 30, 233).withOpacity(0.5),
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 255, 0), // Bold text for title
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.secondaryColor, // Text for the value
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: _employee.name);
    final positionController = TextEditingController(text: _employee.position);
    final departmentController = TextEditingController(text: _employee.department);

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF0D47A1), // Dark Blue
          child: Container(
            width: 400,
            height: 400, // Set the width you prefer
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Employee',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
                const SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: positionController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Position',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a position';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: departmentController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Department',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a department';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog without saving
                      },
                      child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          final updatedEmployee = Employee(
                            id: _employee.id,
                            name: nameController.text,
                            position: positionController.text,
                            department: departmentController.text,
                          );

                          Provider.of<EmployeeProvider>(context, listen: false)
                              .updateEmployee(updatedEmployee)
                              .then((_) {
                            Navigator.of(context).pop();
                            _fetchUpdatedEmployee(context, updatedEmployee.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              AppConstants.createSnackBar(AppConstants.updateEmployeeSuccessMessage,backgroundColor:  Colors.green),
                            );
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2), // Medium-Dark Blue
                      ),
                      child: const Text('Update', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _fetchUpdatedEmployee(BuildContext context, String employeeId) async {
    await Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees();
    final updatedEmployee = Provider.of<EmployeeProvider>(context, listen: false)
        .employees
        .firstWhere((e) => e.id == employeeId);

    setState(() {
      _employee = updatedEmployee;
    });
  }

  void _deleteEmployee(BuildContext context, String employeeId) {
    Provider.of<EmployeeProvider>(context, listen: false)
        .deleteEmployee(employeeId)
        .then((_) {
      Navigator.of(context).pop();
    });
  }
}
