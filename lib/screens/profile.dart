
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/dashboard.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const purple = Color(0xFF7955F5);
  static const ink = Color(0xFF19152F);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final profileAsync = ref.watch(userProfileStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FC),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w800, color: ink),
        ),
        backgroundColor: const Color(0xFFF7F6FC),
        foregroundColor: ink,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF211747), purple, Color(0xFFAA72FF)],
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.17),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'My Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user?.email ?? 'No email available',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account Details',
                style: TextStyle(
                  color: ink,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 13),
            _detailCard(
              icon: Icons.email_outlined,
              title: 'Email Address',
              value: user?.email ?? 'Not available',
            ),
            const SizedBox(height: 12),
            profileAsync.when(
              data: (snapshot) {
                final data = snapshot.data();
                final hours = data?['dailyHours'] ?? 0;
                return _detailCard(
                  icon: Icons.schedule_rounded,
                  title: 'Daily Study Goal',
                  value: '$hours hours per day',
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => _detailCard(
                icon: Icons.schedule_rounded,
                title: 'Daily Study Goal',
                value: 'Unable to load',
              ),
            ),
            const SizedBox(height: 12),
            _detailCard(
              icon: Icons.verified_user_outlined,
              title: 'Account Status',
              value: user == null ? 'Signed out' : 'Signed in',
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
               
onPressed: () async {
  try {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      context.go('/');
    }
  } catch (e) {
    debugPrint('Sign out failed: $e');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign out failed. Please try again.'),
        ),
      );
    }
  }
},

                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFEAE5FA)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EBFF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: purple, size: 23),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF827D98),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
