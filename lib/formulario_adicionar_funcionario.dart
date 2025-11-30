import 'package:flutter/material.dart';
import 'package:myapp/modelo_funcionario.dart';

class AddEmployeeForm extends StatefulWidget {
  final Function(Employee) onSave;
  final Employee? employee;
  final List<String> departments;

  const AddEmployeeForm({
    super.key,
    required this.onSave,
    required this.departments,
    this.employee,
  });

  @override
  State<AddEmployeeForm> createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _position;
  String? _department;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _name = widget.employee!.name;
      _position = widget.employee!.position;
      _department = widget.employee!.department;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.employee == null ? 'Adicionar Novo Funcionário' : 'Editar Funcionário'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  icon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _position,
                decoration: const InputDecoration(
                  labelText: 'Cargo',
                  icon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o cargo';
                  }
                  return null;
                },
                onSaved: (value) {
                  _position = value;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _department,
                decoration: const InputDecoration(
                  labelText: 'Departamento',
                  icon: Icon(Icons.corporate_fare),
                ),
                items: widget.departments.map((String department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Text(department),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _department = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione o departamento';
                  }
                  return null;
                },
                onSaved: (value) {
                  _department = value;
                },
              ),
            ],
          ),
        ),
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
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newEmployee = Employee(
                name: _name!,
                position: _position!,
                department: _department!,
              );
              widget.onSave(newEmployee);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
