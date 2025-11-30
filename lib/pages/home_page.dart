import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/provedor_funcionario.dart';
import 'package:myapp/widgets/formulario_adicionar_funcionario.dart';
import 'package:myapp/pages/funcionarios_page.dart';
import 'package:myapp/pages/departamentos_page.dart';
import 'package:myapp/models/modelo_funcionario.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            leading: const Column(
              children: [
                SizedBox(height: 20),
                Icon(Icons.business, size: 40),
                SizedBox(height: 8),
                Text(
                  'LESC',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 20),
              ],
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Funcionários'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.corporate_fare_outlined),
                selectedIcon: Icon(Icons.corporate_fare),
                label: Text('Departamentos'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                FuncionariosPage(),
                DepartamentosPage(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedIndex == 0) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddEmployeeForm(
                  onSave: (employee) => provider.addEmployee(employee),
                  departments: provider.departments,
                );
              },
            );
          } else {
            _showAddDepartmentDialog(context, provider);
          }
        },
        tooltip: _selectedIndex == 0 ? 'Adicionar Funcionário' : 'Adicionar Departamento',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDepartmentDialog(BuildContext context, EmployeeProvider provider) {
    final TextEditingController departmentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Novo Departamento'),
          content: TextField(
            controller: departmentController,
            decoration: const InputDecoration(labelText: 'Nome do Departamento'),
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
              child: const Text('Adicionar'),
              onPressed: () {
                if (departmentController.text.isNotEmpty) {
                  provider.addDepartment(departmentController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}