import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/tasks'),
          child: const Text('got to tasks'),
        ),
      ),
    );
  }
}
