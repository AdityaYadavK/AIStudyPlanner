import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleBlock {
  final String id;
  final String taskTitle;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // 'pending', 'completed'

  ScheduleBlock({
    required this.id,
    required this.taskTitle,
    required this.startTime,
    required this.endTime,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'taskTitle': taskTitle,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'status': status,
    };
  }

  factory ScheduleBlock.fromMap(String id, Map<String, dynamic> map) {
    return ScheduleBlock(
      id: id,
      taskTitle: map['taskTitle'] ?? '',
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
    );
  }
}
