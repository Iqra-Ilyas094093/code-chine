import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ v7 way — use the singleton instance, no constructor
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  CollectionReference get _usersCollection => _firestore.collection('users');

  // ── REGISTER ──────────────────────────────────────────────

  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
    String? businessName,
    String? phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final firebaseUser = credential.user!;
      await firebaseUser.updateDisplayName(name.trim());

      final user = UserModel(
        uid: firebaseUser.uid,
        name: name.trim(),
        email: email.trim(),
        businessName: businessName?.trim(),
        phone: phone?.trim(),
        createdAt: DateTime.now(),
      );

      await _usersCollection.doc(firebaseUser.uid).set(user.toMap());
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    }
  }

  // ── SIGN IN ───────────────────────────────────────────────

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = credential.user!.uid;
      final doc = await _usersCollection.doc(uid).get();

      if (!doc.exists) {
        await _auth.signOut();
        throw AuthException(
            'You are not registered. Please create an account first.');
      }

      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    }
  }

  // ── GOOGLE SIGN IN ────────────────────────────────────────

  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account == null) {
        throw AuthException('Google sign-in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await account.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 5 — sign into Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;

      // Step 6 — check Firestore for existing user
      final doc = await _usersCollection.doc(firebaseUser.uid).get();

      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        // First time Google login — save to Firestore
        final user = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          email: firebaseUser.email??'Email Error',
          createdAt: DateTime.now(),
        );
        await _usersCollection.doc(firebaseUser.uid).set(user.toMap());
        return user;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    } catch (e,stackTrace) {
      if (e is AuthException) {
        // ← shows real error in console
        debugPrint('GOOGLE ERROR: $e');
        debugPrint('STACK: $stackTrace');

      }
      print(e.toString());
      throw AuthException('Google sign-in failed: ${e.toString()}');
    }
  }

  // ── SIGN OUT ──────────────────────────────────────────────

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),  // ✅ same in v7
    ]);
  }

  // ── FETCH USER ────────────────────────────────────────────

  Future<UserModel?> fetchUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  User? get currentFirebaseUser => _auth.currentUser;

  // ── ERROR MAPPING ─────────────────────────────────────────

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account with this email already exists. Please sign in instead.';
      case 'user-not-found':
        return 'You are not registered. Please create an account first.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'You are not registered or your password is incorrect.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}