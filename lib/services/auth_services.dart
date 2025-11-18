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
    final sanitizedRegNumber = _sanitizeRegNumber(regNumber);

    // Ensure regNumber not already in use
    final regRef = _db.collection('regNumbers').doc(sanitizedRegNumber);
    final regSnap = await regRef.get();
    if (regSnap.exists) throw Exception('Registration number already in use');

    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(regNumber); // optional
    await credential.user!.updateDisplayName(username);

    // Create user doc and mapping
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

    // Send verification email
    await credential.user!.sendEmailVerification();
    return credential;
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
