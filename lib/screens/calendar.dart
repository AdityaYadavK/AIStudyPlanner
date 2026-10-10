import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';

import '../providers/calendar.dart';



class InteractiveCalendarScreen extends ConsumerStatefulWidget {

  const InteractiveCalendarScreen({super.key});



  @override

  ConsumerState<InteractiveCalendarScreen> createState() =>

      _InteractiveCalendarScreenState();

}



class _InteractiveCalendarScreenState

    extends ConsumerState<InteractiveCalendarScreen> {

  final CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay;



  static const List<Color> _weekdayColors = [

    Color(0xFF6C4CE0),

    Color(0xFFE0479E),

    Color(0xFF2FA85A),

    Color(0xFFD79A1E),

    Color(0xFF3B6FE0),

    Color(0xFFE0623B),

    Color(0xFF00B8A9),

  ];



  Color get _accentColor =>

      _weekdayColors[(_selectedDay ?? _focusedDay).weekday - 1];



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



  Future<void> _deleteSchedule(String scheduleId, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF151020),
        title: const Text(
          'Delete study session?',
          style: TextStyle(color: Color(0xFFF5F0FF)),
        ),
        content: Text(
          'Delete "$title" from your calendar?',
          style: const TextStyle(color: Color(0xFFAAA0C5)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFFF6B8A)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('schedules')
          .doc(scheduleId)
          .delete();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Study session deleted')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $error')),
      );
    }
  }

  void _changeDay(int deltaDays) {

    setState(() {

      _selectedDay = (_selectedDay ?? _focusedDay).add(Duration(days: deltaDays));

      _focusedDay = _selectedDay!;

    });

  }



  Future<void> _pickDate(BuildContext context) async {

    final picked = await showDatePicker(

      context: context,

      initialDate: _selectedDay ?? _focusedDay,

      firstDate: DateTime.now().subtract(const Duration(days: 365)),

      lastDate: DateTime.now().add(const Duration(days: 365)),

    );

    if (picked != null) {

      setState(() {

        _selectedDay = picked;

        _focusedDay = picked;

      });

    }

  }



  @override

  Widget build(BuildContext context) {

    final scheduleAsync = ref.watch(scheduleStreamProvider);

    final accent = _accentColor;



    return Scaffold(

      backgroundColor: const Color(0xFF090711),

      appBar: AppBar(

        title: const Text(

          'Study Calendar',

          style: TextStyle(fontWeight: FontWeight.bold),

        ),

        backgroundColor: Colors.transparent,

        elevation: 0,

        foregroundColor: const Color(0xFFF5F0FF),

      ),

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [Color(0xFF10091F), Color(0xFF090711)],

          ),

        ),

        child: scheduleAsync.when(

          data: (schedules) {

            // Filter schedule blocks matching selected day

            final selectedDayBlocks = schedules.where((block) {

              if (_selectedDay == null) return false;

              return isSameDay(block.startTime, _selectedDay);

            }).toList();



            return Column(

              children: [

                // today-only date header, replaces full month grid

                Padding(

                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),

                  child: GestureDetector(

                    onTap: () => _pickDate(context),

                    child: Container(

                      padding: const EdgeInsets.symmetric(

                        horizontal: 20,

                        vertical: 18,

                      ),

                      decoration: BoxDecoration(

                        gradient: LinearGradient(

                          colors: [Color(0xFF5422A8), Color(0xFF9B4DFF)],

                          begin: Alignment.topLeft,

                          end: Alignment.bottomRight,

                        ),

                        borderRadius: BorderRadius.circular(20),

                        boxShadow: [

                          BoxShadow(

                            color: const Color(0xFF9B4DFF).withValues(alpha: 0.28),

                            blurRadius: 14,

                            offset: const Offset(0, 8),

                          ),

                        ],

                      ),

                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [

                          IconButton(

                            onPressed: () => _changeDay(-1),

                            icon: const Icon(

                              Icons.chevron_left_rounded,

                              color: Colors.white,

                              size: 28,

                            ),

                          ),

                          Column(

                            children: [

                              Text(

                                DateFormat('EEEE').format(

                                  _selectedDay ?? _focusedDay,

                                ),

                                style: const TextStyle(

                                  color: Colors.white,

                                  fontSize: 14,

                                  fontWeight: FontWeight.w600,

                                ),

                              ),

                              const SizedBox(height: 2),

                              Text(

                                DateFormat('MMM d, yyyy').format(

                                  _selectedDay ?? _focusedDay,

                                ),

                                style: const TextStyle(

                                  color: Colors.white,

                                  fontSize: 22,

                                  fontWeight: FontWeight.bold,

                                ),

                              ),

                              if (isSameDay(_selectedDay, DateTime.now())) ...[

                                const SizedBox(height: 6),

                                Container(

                                  padding: const EdgeInsets.symmetric(

                                    horizontal: 10,

                                    vertical: 3,

                                  ),

                                  decoration: BoxDecoration(

                                    color: Colors.white.withValues(alpha: 0.25),

                                    borderRadius: BorderRadius.circular(20),

                                  ),

                                  child: const Text(

                                    'TODAY',

                                    style: TextStyle(

                                      color: Colors.white,

                                      fontSize: 11,

                                      fontWeight: FontWeight.bold,

                                      letterSpacing: 1,

                                    ),

                                  ),

                                ),

                              ],

                            ],

                          ),

                          IconButton(

                            onPressed: () => _changeDay(1),

                            icon: const Icon(

                              Icons.chevron_right_rounded,

                              color: Colors.white,

                              size: 28,

                            ),

                          ),

                        ],

                      ),

                    ),

                  ),

                ),

                Expanded(

                  child: selectedDayBlocks.isEmpty

                      ? Center(

                          child: Column(

                            mainAxisSize: MainAxisSize.min,

                            children: [

                              const Text('🗓️', style: TextStyle(fontSize: 48)),

                              const SizedBox(height: 12),

                              const Text(

                                'No study blocks scheduled\nfor this date.',

                                textAlign: TextAlign.center,

                                style: TextStyle(

                                  fontSize: 15,

                                  color: Color(0xFFAAA0C5),

                                ),

                              ),

                            ],

                          ),

                        )

                      : ListView.builder(

                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

                          itemCount: selectedDayBlocks.length,

                          itemBuilder: (context, index) {

                            final block = selectedDayBlocks[index];

                            final isCompleted = block.status == 'completed';

                            final timeRange =

                                '${DateFormat('hh:mm a').format(block.startTime)} - ${DateFormat('hh:mm a').format(block.endTime)}';

                            final blockColor = _weekdayColors[

                                block.startTime.weekday - 1];



                            return Container(

                              margin: const EdgeInsets.only(bottom: 12),

                              decoration: BoxDecoration(

                                color: const Color(0xFF151020),

                                border: Border.all(
                                  color: const Color(0xFF39244F),
                                ),

                                borderRadius: BorderRadius.circular(18),

                                boxShadow: [

                                  BoxShadow(

                                    color: blockColor.withValues(alpha: 0.12),

                                    blurRadius: 10,

                                    offset: const Offset(0, 5),

                                  ),

                                ],

                              ),

                              child: ListTile(

                                shape: RoundedRectangleBorder(

                                  borderRadius: BorderRadius.circular(18),

                                ),

                                leading: Container(

                                  padding: const EdgeInsets.all(10),

                                  decoration: BoxDecoration(

                                    color: (isCompleted

                                            ? Colors.green

                                            : blockColor)

                                        .withValues(alpha: 0.15),

                                    borderRadius: BorderRadius.circular(12),

                                  ),

                                  child: Icon(

                                    isCompleted

                                        ? Icons.check_circle_rounded

                                        : Icons.schedule_rounded,

                                    color: isCompleted

                                        ? Colors.green

                                        : blockColor,

                                  ),

                                ),

                                title: Text(

                                  block.taskTitle,

                                  style: TextStyle(

                                    decoration: isCompleted

                                        ? TextDecoration.lineThrough

                                        : null,

                                    fontWeight: FontWeight.bold,
                                    color: isCompleted
                                        ? const Color(0xFFAAA0C5)
                                        : const Color(0xFFF5F0FF),

                                  ),

                                ),

                                subtitle: Text(
                                  timeRange,
                                  style: const TextStyle(
                                    color: Color(0xFFAAA0C5),
                                    fontSize: 12,
                                  ),
                                ),

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      activeColor: const Color(0xFF9B5CFF),
                                      checkColor: Colors.white,
                                      value: isCompleted,
                                      onChanged: (_) => _toggleScheduleStatus(
                                        block.id,
                                        block.status,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Delete study session',
                                      onPressed: () => _deleteSchedule(
                                        block.id,
                                        block.taskTitle,
                                      ),
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Color(0xFFFF6B8A),
                                      ),
                                    ),
                                  ],
                                ),

                              ),

                            );

                          },

                        ),

                ),

              ],

            );

          },

          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF9B5CFF))),

          error: (err, stack) =>

              Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('Error loading calendar: $err', style: const TextStyle(color: Color(0xFFFF8FA3))))),

        ),

      ),

    );

  }

}