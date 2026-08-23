import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/service.dart';

class AIGeneratorScreen extends ConsumerStatefulWidget {
  const AIGeneratorScreen({super.key});

  @override
  ConsumerState<AIGeneratorScreen> createState() => _AIGeneratorScreenState();
}

class _AIGeneratorScreenState extends ConsumerState<AIGeneratorScreen> {
  bool _isGenerating = false;

  void _generateSchedule() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isGenerating = true);

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final dailyHours =
          (userDoc.data()?['dailyAvailableHours'] ?? 4.0) as double;

      final tasksSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .where('isCompleted', isEqualTo: false)
          .get();

      final tasks = tasksSnapshot.docs.map((d) {
        final data = d.data();
        return {
          'title': data['title'],
          'estimatedMinutes': data['estimatedMinutes'],
          'dueDate': (data['dueDate'] as Timestamp).toDate().toIso8601String(),
        };
      }).toList();

      if (tasks.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No pending tasks to schedule! Add tasks first.'),
            ),
          );
        }
        return;
      }

      // Replace with your actual Gemini API Key
      final aiService = AIService(apiKey: 'YOUR_GEMINI_API_KEY');
      final scheduleBlocks = await aiService.generateSchedule(
        dailyHours: dailyHours,
        tasks: tasks,
      );

      // Batch write calculated schedules into Firestore
      final batch = FirebaseFirestore.instance.batch();
      final scheduleRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('schedules');

      final baseTime = DateTime.now().copyWith(hour: 9, minute: 0, second: 0);

      for (var block in scheduleBlocks) {
        final docRef = scheduleRef.doc();
        final start = baseTime.add(
          Duration(minutes: block['startOffsetMinutes'] ?? 0),
        );
        final end = start.add(
          Duration(minutes: block['durationMinutes'] ?? 30),
        );

        batch.set(docRef, {
          'taskTitle': block['taskTitle'],
          'startTime': Timestamp.fromDate(start),
          'endTime': Timestamp.fromDate(end),
          'status': 'pending',
        });
      }

      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI Study Schedule generated successfully!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Generation failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Schedule Generator')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 100, color: Colors.amber),
            const SizedBox(height: 24),
            const Text(
              'Generate Personalized Study Routine',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Our AI engine evaluates your pending tasks, estimated duration, exam deadlines, and daily available study time to create an optimized routine.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateSchedule,
                icon: _isGenerating
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.flash_on),
                label: Text(
                  _isGenerating
                      ? 'Generating Schedule...'
                      : 'Generate Schedule Now',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
