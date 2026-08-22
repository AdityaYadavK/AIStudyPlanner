import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Center(
      	child : ElevatedButton(
	     		onPressed: () => context.go('/generator'),
	       	child : const Text('go to generator')
       )
      )
    );
  }
}
