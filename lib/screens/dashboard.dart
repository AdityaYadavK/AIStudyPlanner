import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/dashboard.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(userTasksStreamProvider);
    final userAsync = ref.watch(userProfileStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                context.go('/');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // user stats section
            userAsync.when(
              data: (snapshot) {
                final data = snapshot.data();
                final dailyHours = data?['dailyHours'] ?? 0.0;
                return Card(
                  color: Colors.deepPurple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 40,
                          color: Colors.deepPurple,
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Goal Target',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('$dailyHours Hours / Day available for study'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => LinearProgressIndicator(),
              error: (err, stack) => Text('error loading profile : $err'),
            ),
            const SizedBox(height: 16),

            // navigation grid
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildActionCard(
                  context,
                  title: 'subjects',
                  icon: Icons.book,
                  color: Colors.blue.shade100,
                  onTap: () => context.push('/subjects'),
                ),
                _buildActionCard(
                  context,
                  title: 'Add Tasks',
                  icon: Icons.book,
                  color: Colors.blue.shade100,
                  onTap: () => context.push('/tasks'),
                ),
                _buildActionCard(
                  context,
                  title: 'AI Generator',
                  icon: Icons.book,
                  color: Colors.blue.shade100,
                  onTap: () => context.push('/generator'),
                ),
                _buildActionCard(
                  context,
                  title: 'calendar',
                  icon: Icons.book,
                  color: Colors.blue.shade100,
                  onTap: () => context.push('/calendar'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // pending tasks overview
            const Text(
              'upcoming deadline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            tasksAsync.when(
              data: (snapshot) {
                if (snapshot.docs.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('no task found, add tasks to get started'),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.docs[index];
                    final data = doc.data();
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.assignment),
                        title: Text(data['title'] ?? 'Untitled'),
                        subtitle: Text(
                          'Est. Time: ${data['estimatedMinutes']} mins',
                        ),
                        trailing: Icon(
                          data['isCompleted'] == true
                              ? Icons.check_circle
                              : Icons.pending,
                          color: data['isCompleted'] == true
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading tasks: $err'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
