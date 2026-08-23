import 'package:cloud_firestore/cloud_firestore.dart';

class TaskItem {
  final String id;
  final String subjectId;
  final String title;
  final DateTime dueDate;
  final int estimatedMinutes;
  final bool isCompleted;

  TaskItem({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.dueDate,
    required this.estimatedMinutes,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'subjectId': subjectId,
      'title': title,
      'dueDate': Timestamp.fromDate(dueDate),
      'estimatedMinutes': estimatedMinutes,
      'isCompleted': isCompleted,
    };
  }

  factory TaskItem.fromMap(String id, Map<String, dynamic> map) {
    return TaskItem(
      id: id,
      subjectId: map['subjectId'] ?? '',
      title: map['title'] ?? '',
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      estimatedMinutes: map['estimatedMinutes'] ?? 30,
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
