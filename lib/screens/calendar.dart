import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/schedule.dart';
import '../providers/calendar.dart';

class InteractiveCalendarScreen extends ConsumerStatefulWidget {
  const InteractiveCalendarScreen({super.key});

  @override
  ConsumerState<InteractiveCalendarScreen> createState() =>
      _InteractiveCalendarScreenState();
}

class _InteractiveCalendarScreenState
    extends ConsumerState<InteractiveCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _toggleScheduleStatus(String scheduleId, String currentStatus) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final newStatus = currentStatus == 'completed' ? 'pending' : 'completed';

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('schedules')
        .doc(scheduleId)
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = ref.watch(scheduleStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Study Calendar')),
      body: scheduleAsync.when(
        data: (schedules) {
          // Filter schedule blocks matching selected day
          final selectedDayBlocks = schedules.where((block) {
            if (_selectedDay == null) return false;
            return isSameDay(block.startTime, _selectedDay);
          }).toList();

          return Column(
            children: [
              TableCalendar<ScheduleBlock>(
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() => _calendarFormat = format);
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: (day) {
                  return schedules
                      .where((b) => isSameDay(b.startTime, day))
                      .toList();
                },
              ),
              const Divider(),
              Expanded(
                child: selectedDayBlocks.isEmpty
                    ? const Center(
                        child: Text('No study blocks scheduled for this date.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: selectedDayBlocks.length,
                        itemBuilder: (context, index) {
                          final block = selectedDayBlocks[index];
                          final isCompleted = block.status == 'completed';
                          final timeRange =
                              '${DateFormat('hh:mm a').format(block.startTime)} - ${DateFormat('hh:mm a').format(block.endTime)}';

                          return Card(
                            color: isCompleted ? Colors.green.shade50 : null,
                            child: ListTile(
                              leading: Icon(
                                isCompleted
                                    ? Icons.check_circle
                                    : Icons.schedule,
                                color: isCompleted
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              title: Text(
                                block.taskTitle,
                                style: TextStyle(
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(timeRange),
                              trailing: Checkbox(
                                value: isCompleted,
                                onChanged: (_) => _toggleScheduleStatus(
                                  block.id,
                                  block.status,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error loading calendar: $err')),
      ),
    );
  }
}
