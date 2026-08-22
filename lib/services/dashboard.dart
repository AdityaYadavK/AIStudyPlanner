import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// stream of tasks for the authenticated users
final userTasksStreamProvider = StreamProvider.autoDispose((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('tasks')
      .orderBy('dueDate', descending: false)
      .snapshots();
});

// stream of user profile data
final userProfileStreamProvider = StreamProvider.autoDispose((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return const Stream.empty();

  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
});


