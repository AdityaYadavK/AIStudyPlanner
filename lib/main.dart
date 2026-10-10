import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'core/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase init will added here
  try {
    print('Initializing Firebase...');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    
    // Configure Firestore settings - disabling persistence initially to debug connectivity
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    
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
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF090711),

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF9B5CFF),
    secondary: Color(0xFF00F5FF),
    surface: Color(0xFF151020),
    onPrimary: Colors.white,
    onSecondary: Color(0xFF090711),
    onSurface: Color(0xFFF5F0FF),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF090711),
    foregroundColor: Color(0xFFF5F0FF),
    elevation: 0,
    centerTitle: false,
  ),

  cardTheme: CardThemeData(
    color: const Color(0xFF151020),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: const BorderSide(
        color: Color(0xFF302044),
      ),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
      minimumSize: const Size(0, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w800,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF151020),
    labelStyle: const TextStyle(
      color: Color(0xFFB8A8D8),
    ),
    hintStyle: const TextStyle(
      color: Color(0xFF756A89),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF302044),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF302044),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFF9B5CFF),
        width: 1.5,
      ),
    ),
  ),

  dividerColor: const Color(0xFF302044),
),

      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
