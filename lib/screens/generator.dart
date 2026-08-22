import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GeneratorScreen extends StatelessWidget {
  const GeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Plan Generator')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/calendar'),
          child: const Text('go to calendar'),
        ),
      ),
    );
  }
}
