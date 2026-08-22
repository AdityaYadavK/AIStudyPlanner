import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body : Center(
      	child : ElevatedButton(
     			onPressed: () => context.go('/subjects'),
        	child : const Text('go to subjects')
       )
      )
    );
  }
}
