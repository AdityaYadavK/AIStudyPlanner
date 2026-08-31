import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase init will added here
  try {
    print('Initializing Firebase...');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AI Study Planner',
      theme: ThemeData(
      	useMaterial3: true,
       	colorScheme: ColorScheme.fromSeed(
        	seedColor: Colors.deepPurple,
         	brightness: Brightness.light
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
