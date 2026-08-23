import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule.dart';

final scheduleStreamProvider = StreamProvider.autoDispose<List<ScheduleBlock>>((
  ref,
) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('schedules')
      .orderBy('startTime', descending: false)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => ScheduleBlock.fromMap(doc.id, doc.data()))
            .toList(),
      );
});
