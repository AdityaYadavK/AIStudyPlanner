import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject.dart';
import '../providers/subject.dart';

class SubjectManagerScreen extends ConsumerWidget {
  const SubjectManagerScreen({super.key});

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
              title: Text(subject == null ? 'Add Subject' : 'Edit Subject'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Title',
                      border: OutlineInputBorder(),
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
      appBar: AppBar(title: const Text('Subject Manager')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSubjectDialog(context),
        child: const Icon(Icons.add),
      ),
      body: subjectsAsync.when(
        data: (subjects) {
          if (subjects.isEmpty) {
            return const Center(
              child: Text('No subjects added yet. Tap + to add one!'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${subject.difficulty}')),
                  title: Text(subject.title),
                  subtitle: Text(
                    'Difficulty Rating: Level ${subject.difficulty}/5',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _showSubjectDialog(context, subject: subject),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
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
    );
  }
}
