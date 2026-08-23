import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/subject.dart';

class TaskInputScreen extends ConsumerStatefulWidget {
  const TaskInputScreen({super.key});

  @override
  ConsumerState<TaskInputScreen> createState() => _TaskInputScreenState();
}

class _TaskInputScreenState extends ConsumerState<TaskInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _estimatedTimeController = TextEditingController(text: '60');

  String? _selectedSubjectId;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;

  void _submitTask() async {
    if (!_formKey.currentState!.validate() || _selectedSubjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subject and fill all fields.')),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .add({
        'subjectId': _selectedSubjectId,
        'title': _titleController.text.trim(),
        'dueDate': Timestamp.fromDate(_selectedDate),
        'estimatedMinutes': int.parse(_estimatedTimeController.text.trim()),
        'isCompleted': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjectsAsync = ref.watch(subjectsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task / Exam'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject selection dropdown
              subjectsAsync.when(
                data: (subjects) {
                  if (subjects.isEmpty) {
                    return const Text(
                      'No subjects found. Please create a subject in Subject Manager first!',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    value: _selectedSubjectId,
                    decoration: const InputDecoration(
                      labelText: 'Select Subject',
                      border: OutlineInputBorder(),
                    ),
                    items: subjects
                        .map((s) => DropdownMenuItem(
                              value: s.id,
                              child: Text(s.title),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedSubjectId = val),
                    validator: (val) => val == null ? 'Subject is required' : null,
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (err, _) => Text('Error loading subjects: $err'),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task / Topic Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Enter a task title' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _estimatedTimeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Estimated Prep Time (in Minutes)',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || int.tryParse(val.trim()) == null) {
                    return 'Enter a valid number of minutes';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Target Due Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitTask,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Save Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
