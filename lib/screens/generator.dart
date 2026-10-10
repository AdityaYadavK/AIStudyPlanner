
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIGeneratorScreen extends ConsumerStatefulWidget {
  const AIGeneratorScreen({super.key});

  @override
  ConsumerState<AIGeneratorScreen> createState() =>
      _AIGeneratorScreenState();
}

class _AIGeneratorScreenState
    extends ConsumerState<AIGeneratorScreen> {
  bool _isGenerating = false;
  bool _savedToCloud = false;

  List<Map<String, dynamic>> _schedule = [];

  static const _purple = Color(0xFF7955F5);
  static const _ink = Color(0xFF19152F);

  Future<void> _generateSchedule() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in first.')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _savedToCloud = false;
      _schedule = [];
    });

    try {
      final subjects = [
        'Mathematics',
        'Physics',
        'Chemistry',
        'Biology',
        'English',
        'History',
        'Computer Science',
        'Economics',
      ];

      final activities = [
        'Review Notes',
        'Practice Problems',
        'Read Chapter',
        'Watch Tutorial',
        'Complete Assignment',
        'Self-Quiz',
        'Revise Important Topics',
      ];

      final random = Random();
      final now = DateTime.now();
      final baseTime = DateTime(
        now.year,
        now.month,
        now.day,
        9,
      );

      final blocks = <Map<String, dynamic>>[];
      var offset = 0;
      final count = 4 + random.nextInt(3);

      for (var i = 0; i < count; i++) {
        final duration = 45 + random.nextInt(31);
        final start = baseTime.add(Duration(minutes: offset));
        final end = start.add(Duration(minutes: duration));

        blocks.add({
          'taskTitle':
              '${subjects[random.nextInt(subjects.length)]} - '
              '${activities[random.nextInt(activities.length)]}',
          'startTime': start,
          'endTime': end,
          'durationMinutes': duration,
        });

        offset += duration + 15;
      }

      // Display the generated schedule even if cloud saving fails.
      if (mounted) {
        setState(() => _schedule = blocks);
      }

      try {
        final firestore = FirebaseFirestore.instance;
        final batch = firestore.batch();
        final collection = firestore
            .collection('users')
            .doc(uid)
            .collection('schedules');

        for (final block in blocks) {
          final doc = collection.doc();

          batch.set(doc, {
            'taskTitle': block['taskTitle'],
            'startTime': Timestamp.fromDate(
              block['startTime'] as DateTime,
            ),
            'endTime': Timestamp.fromDate(
              block['endTime'] as DateTime,
            ),
            'durationMinutes': block['durationMinutes'],
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        await batch.commit();

        if (mounted) {
          setState(() => _savedToCloud = true);
        }
      } catch (e) {
        debugPrint('Schedule cloud save failed: $e');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _savedToCloud
                  ? 'Schedule generated and saved!'
                  : 'Schedule generated on screen, but cloud save failed.',
            ),
            backgroundColor:
                _savedToCloud ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      debugPrint('Schedule generation failed: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not generate schedule. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  String _time(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FC),
      appBar: AppBar(
        title: const Text(
          'AI Schedule Generator',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFF7F6FC),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_schedule.isEmpty) ...[
            const SizedBox(height: 70),
            const Icon(
              Icons.auto_awesome_rounded,
              size: 90,
              color: Colors.amber,
            ),
            const SizedBox(height: 24),
            const Text(
              'Generate Personalized Study Routine',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _ink,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Create a sample daily study routine with sessions, '
              'durations and breaks.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_ink, _purple, Color(0xFFAA72FF)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOUR STUDY PLAN',
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 1.2,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_schedule.length} study sessions planned',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _savedToCloud
                        ? 'Saved to your account'
                        : 'Currently displayed on this screen',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Today’s Routine',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: _ink,
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < _schedule.length; i++) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFEAE5FA),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EBFF),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: _purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _schedule[i]['taskTitle'] as String,
                            style: const TextStyle(
                              color: _ink,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '${_time(_schedule[i]['startTime'] as DateTime)}'
                            ' – '
                            '${_time(_schedule[i]['endTime'] as DateTime)}',
                            style: const TextStyle(
                              color: _purple,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_schedule[i]['durationMinutes']} minutes'
                            ' • 15-minute break afterwards',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _isGenerating ? null : _generateSchedule,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Generate Another Schedule'),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateSchedule,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome_rounded),
              label: Text(
                _isGenerating
                    ? 'Generating Schedule...'
                    : _schedule.isEmpty
                        ? 'Generate Schedule Now'
                        : 'Regenerate Schedule',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _purple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
