import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/provedor_funcionario.dart';
import 'package:myapp/pages/department_details_page.dart';

class DepartamentosPage extends StatelessWidget {
  const DepartamentosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Departamentos', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    '${provider.departments.length} departamentos',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: provider.departments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.corporate_fare_outlined, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum departamento cadastrado',
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.departments.length,
                        itemBuilder: (context, index) {
                          final department = provider.departments[index];
                          final employeesInDepartment = provider.employees
                              .where((e) => e.department == department)
                              .toList();

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue[100],
                                child: const Icon(Icons.corporate_fare, color: Colors.blue),
                              ),
                              title: Text(department, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                              subtitle: Text(
                                '${employeesInDepartment.length} funcionário(s)',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              trailing: PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditDepartmentDialog(context, provider, index, department);
                                  } else if (value == 'delete') {
                                    _showDeleteDepartmentDialog(context, provider, index, department, employeesInDepartment.length);
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20, color: Colors.blueGrey),
                                        SizedBox(width: 8),
                                        Text('Editar'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: Colors.redAccent),
                                        SizedBox(width: 8),
                                        Text('Excluir'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DepartmentDetailsPage(
                                      departmentName: department,
                                      employees: employeesInDepartment,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDepartmentDialog(BuildContext context, EmployeeProvider provider, int index, String currentName) {
    final TextEditingController controller = TextEditingController(text: currentName);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Departamento'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nome do Departamento',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (controller.text.isNotEmpty && controller.text != currentName) {
                  provider.editDepartment(index, controller.text);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Departamento atualizado com sucesso!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDepartmentDialog(BuildContext context, EmployeeProvider provider, int index, String departmentName, int employeeCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Deseja realmente excluir o departamento "$departmentName"?'),
              if (employeeCount > 0) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Este departamento possui $employeeCount funcionário(s). Eles ficarão sem departamento!',
                          style: TextStyle(color: Colors.orange[900], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Excluir'),
              onPressed: () {
                provider.deleteDepartment(index);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Departamento "$departmentName" excluído!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}