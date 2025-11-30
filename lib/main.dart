import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/formulario_adicionar_funcionario.dart';
import 'package:myapp/provedor_funcionario.dart';
import 'package:myapp/app_router.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EmployeeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'LESC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardThemeData(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

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

class FuncionariosPage extends StatelessWidget {
  const FuncionariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmployeeProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Funcionários', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar funcionário...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.employees.length,
                  itemBuilder: (context, index) {
                    final employee = provider.employees[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.person, size: 40, color: Colors.blueAccent),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(employee.position, style: const TextStyle(color: Colors.black54)),
                                  Text(employee.department, style: const TextStyle(color: Colors.black54, fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueGrey),
                                  tooltip: 'Editar',
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AddEmployeeForm(
                                          onSave: (editedEmployee) {
                                            provider.editEmployee(index, editedEmployee);
                                          },
                                          employee: employee,
                                          departments: provider.departments,
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  tooltip: 'Excluir',
                                  onPressed: () => provider.deleteEmployee(index),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}

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
              Text('Departamentos', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: provider.departments.length,
                  itemBuilder: (context, index) {
                    final department = provider.departments[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.corporate_fare, color: Colors.blueAccent),
                        title: Text(department, style: const TextStyle(fontWeight: FontWeight.w500)),
                        onTap: () {
                          // Navegação para a página de funcionários do departamento
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
}
