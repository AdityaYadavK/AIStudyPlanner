import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../providers/subject.dart';

class SubjectManagerScreen extends ConsumerWidget {
  const SubjectManagerScreen({super.key});

  static const List<Color> _palette = [
    Color(0xFF6C4CE0),
    Color(0xFFE0479E),
    Color(0xFF2FA85A),
    Color(0xFFD79A1E),
    Color(0xFF3B6FE0),
    Color(0xFFE0623B),
  ];

  Color _colorFor(String seed) {
    final hash = seed.codeUnits.fold<int>(0, (a, b) => a + b);
    return _palette[hash % _palette.length];
  }

  void _showSubjectDialog(BuildContext context, {Subject? subject}) {
    final titleController = TextEditingController(text: subject?.title ?? '');
    int difficulty = subject?.difficulty ?? 3;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                subject == null ? '✨ Add Subject' : '✏️ Edit Subject',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Subject Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Difficulty: '),
                      DropdownButton<int>(
                        value: difficulty,
                        items: List.generate(5, (index) => index + 1)
                            .map(
                              (level) => DropdownMenuItem(
                                value: level,
                                child: Text('Level $level'),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => difficulty = val);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4CE0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) return;

                    final collection = FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('subjects');

                    if (subject == null) {
                      await collection.add({
                        'title': titleController.text.trim(),
                        'difficulty': difficulty,
                      });
                    } else {
                      await collection.doc(subject.id).update({
                        'title': titleController.text.trim(),
                        'difficulty': difficulty,
                      });
                    }

                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(subject == null ? 'Save' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteSubject(String subjectId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('subjects')
        .doc(subjectId)
        .delete();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FB),
      appBar: AppBar(
        title: const Text(
          'Subject Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C4CE0),
        onPressed: () => _showSubjectDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF3E9FF), Color(0xFFE8F0FF)],
          ),
        ),
        child: subjectsAsync.when(
          data: (subjects) {
            if (subjects.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('📚', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 12),
                    const Text(
                      'No subjects added yet.\nTap + to add one!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                final color = _colorFor(subject.title);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: color.withOpacity(0.15),
                      child: Text(
                        '${subject.difficulty}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    title: Text(
                      subject.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < subject.difficulty
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            size: 16,
                            color: color,
                          );
                        }),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: Color(0xFF3B6FE0),
                          ),
                          onPressed: () =>
                              _showSubjectDialog(context, subject: subject),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_rounded,
                            color: Color(0xFFE0623B),
                          ),
                          onPressed: () => _deleteSubject(subject.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('Error loading subjects: $err')),
        ),
      ),
    );
  }
}
