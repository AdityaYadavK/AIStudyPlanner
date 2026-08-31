import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required double dailyAvailableHours,
  }) async {
    try {
      print('Attempting to create user with email: $email');
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User created successfully: ${credential.user?.uid}');

      // init user profile in firestore
      print('Creating Firestore document for user');
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'dailyAvailableHours': dailyAvailableHours,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Firestore document created successfully');
      return credential;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('General exception during sign up: $e');
      print('Exception type: ${e.runtimeType}');
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _handleAuthException(FirebaseAuthException e) {
    print('Handling Firebase Auth Exception:');
    print('  Code: ${e.code}');
    print('  Message: ${e.message}');
    print('  Email: ${e.email}');
    
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please use a different email or login.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      default:
        return 'Authentication failed (Code: ${e.code}): ${e.message ?? "Unknown error"}';
    }
  }
}
