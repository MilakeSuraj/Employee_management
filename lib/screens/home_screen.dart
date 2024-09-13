import 'package:employee_management/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/employee_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch employees when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees();
    });
    _searchController.addListener(_updateSearchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context);
    final employees = provider.employees.where((employee) {
      return employee.id.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management', style: TextStyle(color: AppConstants.secondaryColor)),
        backgroundColor: const Color(0xFF0D47A1),  // Dark blue from the screenshot
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D47A1),  // Dark blue
              Color(0xFF1976D2),  // Medium-dark blue
              Color(0xFF42A5F5),  // Medium-light blue
              Color(0xFF90CAF9),  // Bright light blue
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by ID',
                  hintStyle: TextStyle(color: Colors.grey[300]),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  contentPadding: const EdgeInsets.all(8.0),
                ),
                onSubmitted: _onSearchSubmitted,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Employees',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Add Employee',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.pushNamed(context, '/add');
                            },
                            color: Colors.white,
                            tooltip: 'Add Employee',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
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
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : employees.isEmpty
                      ? const Center(child: Text('Employee details not found !!', style: TextStyle(fontSize: 22.0, color: Colors.red)))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(), // Prevents scrolling issues
                          itemCount: employees.length,
                          itemBuilder: (context, index) {
                            final employee = employees[index];
                            return Card(
                              color: const Color.fromARGB(255, 15, 30, 233).withOpacity(0.5),
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              elevation: 4.0,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16.0),
                                title: Text(
                                  employee.name,
                                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                trailing: IconButton(
                                  iconSize: 40,
                                  icon: const Icon(Icons.navigate_next),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/details',
                                      arguments: employee,
                                    );
                                  },
                                  color: Colors.white,
                                  tooltip: 'View Details',
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
