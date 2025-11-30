import 'package:flutter/material.dart';
import 'package:myapp/models/modelo_funcionario.dart';

class EmployeeProvider with ChangeNotifier {
  final List<Employee> _employees = [
    Employee(name: 'Alice', position: 'Desenvolvedora', department: 'Engenharia'),
    Employee(name: 'Bob', position: 'Gerente de Produto', department: 'Produto'),
  ];

  final List<String> _departments = ['Engenharia', 'Produto', 'RH', 'Marketing', 'Vendas'];

  List<Employee> get employees => _employees;
  List<String> get departments => _departments;

  void addEmployee(Employee employee) {
    _employees.add(employee);
    notifyListeners();
  }

  void editEmployee(int index, Employee employee) {
    _employees[index] = employee;
    notifyListeners();
  }

  void deleteEmployee(int index) {
    _employees.removeAt(index);
    notifyListeners();
  }

  void addDepartment(String department) {
    _departments.add(department);
    notifyListeners();
  }

  void editDepartment(int index, String newName) {
    final oldName = _departments[index];
    _departments[index] = newName;
    
    for (var employee in _employees) {
      if (employee.department == oldName) {
        employee.department = newName;
      }
    }
    
    notifyListeners();
  }

  void deleteDepartment(int index) {
    _departments.removeAt(index);
    notifyListeners();
  }
}