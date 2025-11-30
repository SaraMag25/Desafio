
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pagina_funcionarios_departamento.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <GoRoute>[
        GoRoute(
          path: 'departamento/:department',
          builder: (BuildContext context, GoRouterState state) {
            final department = state.pathParameters['department']!;
            return DepartmentEmployeesPage(department: department);
          },
        ),
      ],
    ),
  ],
);
