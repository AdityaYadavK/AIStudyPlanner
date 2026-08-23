import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner/models/subject.dart';

final subjectsStreamProvider = StreamProvider.autoDispose<List<Subject>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('subjects')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Subject.fromMap(doc.id, doc.data()))
            .toList(),
      );
});
