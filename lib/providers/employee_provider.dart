
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/employee.dart';

class EmployeeProvider with ChangeNotifier {
  final String _baseUrl = 'http://10.0.2.2:3000/employees'; // Change this for different environments
  List<Employee> _employees = [];
  bool _isLoading = false;

  List<Employee> get employees => _employees;
  bool get isLoading => _isLoading;

  Future<void> fetchEmployees() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _employees = data.map((e) => Employee.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (error) {
      print('Error fetching employees: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employee.toJson()),
      );
      if (response.statusCode == 201) {
        _employees.add(Employee.fromJson(json.decode(response.body)));
        notifyListeners();
      } else {
        throw Exception('Failed to add employee');
      }
    } catch (error) {
      print('Error adding employee: $error');
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${employee.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(employee.toJson()),
      );
      if (response.statusCode == 200) {
        final index = _employees.indexWhere((e) => e.id == employee.id);
        if (index != -1) {
          _employees[index] = Employee.fromJson(json.decode(response.body));
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update employee');
      }
    } catch (error) {
      print('Error updating employee: $error');
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id'));
      if (response.statusCode == 200) {
        _employees.removeWhere((e) => e.id == id);
        notifyListeners();
      } else {
        throw Exception('Failed to delete employee');
      }
    } catch (error) {
      print('Error deleting employee: $error');
    }
  }

  // Method to check if an ID exists
  Future<bool> isIdExists(String id) async {
    try {
      await fetchEmployees(); // Ensure employees are up-to-date
      return _employees.any((employee) => employee.id == id);
    } catch (error) {
      print('Error checking if ID exists: $error');
      return false;
    }
  }
}
