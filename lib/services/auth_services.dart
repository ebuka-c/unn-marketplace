import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();
  factory AuthService() => instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Helper method to sanitize reg numbers for Firestore IDs
  String _sanitizeRegNumber(String regNumber) {
    return regNumber.replaceAll('/', '-');
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String regNumber,
    required String username,
  }) async {
    try {
      // Check if reg number is valid against the centralized school database
      final doc = await _db.collection('schoolData').doc('studentsList').get();

      if (!doc.exists ||
          !(doc.data()?['registered_students'] as List<dynamic>).contains(
            regNumber,
          )) {
        throw Exception(
          'The registration number you submitted does not belong to a registered student',
        );
      }

      // Existing check to ensure reg number not in use in regNumbers collection (optional)
      final sanitizedRegNumber = _sanitizeRegNumber(regNumber.trim());
      final regRef = _db.collection('regNumbers').doc(sanitizedRegNumber);
      final regSnap = await regRef.get();
      if (regSnap.exists) throw Exception('Registration number already in use');

      // Proceed with Firebase Authentication sign up and user doc creation
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName(username);

      await _db.collection('users').doc(credential.user!.uid).set({
        'email': email,
        'regNumber': regNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await regRef.set({
        'uid': credential.user!.uid,
        'email': email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await credential.user!.sendEmailVerification();

      return credential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('The email address is already registered.');
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'weak-password':
          throw Exception(
            'The password is too weak. Please choose a stronger password.',
          );
        case 'operation-not-allowed':
          throw Exception('Email/Password sign up is not enabled.');
        default:
          throw Exception('Failed to sign up: ${e.message}');
      }
    }
  }

  Future<UserCredential> signInWithEmailOrReg({
    required String id,
    required String password,
  }) async {
    String emailOrReg = id.trim();

    // If it looks like a reg number (no @), sanitize it and resolve
    if (!emailOrReg.contains('@')) {
      final sanitizedRegNumber = _sanitizeRegNumber(emailOrReg);
      final regDoc = await _db
          .collection('regNumbers')
          .doc(sanitizedRegNumber)
          .get();

      if (!regDoc.exists ||
          regDoc.data() == null ||
          regDoc.data()!['email'] == null) {
        throw Exception('Registration number not found');
      }
      emailOrReg = regDoc.data()!['email'];
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: emailOrReg,
        password: password,
      );
      return credential;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
