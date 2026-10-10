
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Register a new user and create their Firestore profile.
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required double dailyAvailableHours,
  }) async {
    UserCredential? credential;

    try {
      final normalizedEmail = email.trim();

      print('Sign up started for: $normalizedEmail');

      // Step 1: Create Firebase Authentication account.
      credential = await _auth
          .createUserWithEmailAndPassword(
            email: normalizedEmail,
            password: password,
          )
          .timeout(const Duration(seconds: 20));

      final user = credential.user;

      if (user == null) {
        throw Exception('Firebase did not return a user.');
      }

      print('Authentication successful: ${user.uid}');

      // Step 2: Save the user's profile in Firestore.
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
            'uid': user.uid,
            'email': normalizedEmail,
            'dailyAvailableHours': dailyAvailableHours,
            'createdAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 15));

      print('Firestore profile saved successfully.');

      return credential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth error: ${e.code}');

      throw Exception(_handleAuthException(e));
    } on TimeoutException {
      print('Sign up timed out.');

      throw Exception(
        credential == null
            ? 'Registration timed out. Check your internet and Firebase Authentication.'
            : 'Account may already be created, but saving the profile timed out. Check Firestore.',
      );
    } on FirebaseException catch (e) {
      print('Firebase error: ${e.code} - ${e.message}');

      throw Exception(
        credential != null
            ? 'Account created, but profile saving failed (${e.code}). Check Firestore rules and connection.'
            : 'Firebase error (${e.code}). Please try again.',
      );
    } catch (e) {
      print('Unexpected sign-up error: $e');

      rethrow;
    }
  }

  // Log in an existing user.
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password,
          )
          .timeout(const Duration(seconds: 20));
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } on TimeoutException {
      throw Exception(
        'Login timed out. Please check your internet connection.',
      );
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  // Log out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Convert Firebase Auth error codes into readable messages.
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please log in instead.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'operation-not-allowed':
        return 'Email/password login is disabled in Firebase Console.';

      case 'weak-password':
        return 'Your password is too weak. Please choose a stronger password.';

      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again later.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password. Please try again.';

      default:
        return 'Authentication failed (${e.code}): ${e.message ?? 'Unknown error'}';
    }
  }
}
