import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool isLogin = true;
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  double _dailyHours = 6.0;

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        await _authService.login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await _authService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          dailyAvailableHours: _dailyHours,
        );
      }
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        print('Auth Error: $e');
        print('Error Type: ${e.runtimeType}');
        String errorMessage = 'An error occurred';
        if (e is Exception) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else {
          errorMessage = e.toString();
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 16),
                  Text(
                    isLogin ? 'welcome back' : 'create account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (v) => v != null && v.contains('@')
                        ? null
                        : 'enter a valid email',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (v) =>
                        v != null && v.length >= 6 ? null : 'min 6char',
                  ),
                  if (!isLogin) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Daily Available Study Hours: ${_dailyHours.toStringAsFixed(1)} hrs',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: _dailyHours,
                      min: 1.0,
                      max: 12.0,
                      divisions: 22,
                      label: '${_dailyHours.toStringAsFixed(1)} hrs',
                      onChanged: (val) => setState(() => _dailyHours = val),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(isLogin ? 'Login' : 'Register'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(isLogin
                        ? "Don't have an account? Register"
                        : 'Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
