import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/provedor_funcionario.dart';

class DepartmentEmployeesPage extends StatelessWidget {
  final String department;

  const DepartmentEmployeesPage({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(department),
      ),
      body: Consumer<EmployeeProvider>(
        builder: (context, provider, child) {
          final employees = provider.employees.where((e) => e.department == department).toList();
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(employee.name),
                  subtitle: Text(employee.position),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
