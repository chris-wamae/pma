import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel?> signUp(String email, String password, {String? name, String role = 'Owner'}) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore
      UserModel newUser = UserModel(
        uid: credential.user!.uid,
        email: email,
        name: name,
        role: role,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toJson());
      return newUser;
    } catch (e) {
      print('FirebaseAuthService signUp error: $e');
      return null;
    }
  }

  @override
  Future<Map<String, String>?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // We return a dummy map because Firebase Auth handles tokens internally via the SDK.
      // The repository expected tokens, but we can just signal success.
      return {
        'accessToken': credential.user!.uid,
        'refreshToken': 'firebase_managed',
      };
    } catch (e) {
      print('FirebaseAuthService signIn error: $e');
      return null;
    }
  }

  @override
  Future<bool> sendOtp(String email) async {
    // Firebase Auth doesn't support email OTP via SDK in the same way as SMS.
    // Email verification is the standard.
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        return true;
      }
      return false;
    } catch (e) {
      print('FirebaseAuthService sendOtp error: $e');
      return false;
    }
  }

  @override
  Future<bool> verifyOtp(String email, String code) async {
    // Firebase doesn't use a "code" for email verification; the user clicks a link.
    // We check if the user is now verified.
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        return user.emailVerified;
      }
      return false;
    } catch (e) {
      print('FirebaseAuthService verifyOtp error: $e');
      return false;
    }
  }

  @override
  Future<bool> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print('FirebaseAuthService sendPasswordReset error: $e');
      return false;
    }
  }

  @override
  Future<bool> resetPassword(String email, String token, String newPassword) async {
    // Firebase handles password reset via an email link.
    // Manual reset is only possible if the user is signed in.
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        return true;
      }
      return false;
    } catch (e) {
      print('FirebaseAuthService resetPassword error: $e');
      return false;
    }
  }

  @override
  Future<Map<String, String>?> refreshToken(String refreshToken) async {
    // Handled automatically by Firebase SDK.
    return {
      'accessToken': _auth.currentUser?.uid ?? '',
      'refreshToken': 'firebase_managed',
    };
  }

  @override
  Future<void> signOut(String uid) async {
    await _auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('FirebaseAuthService getCurrentUser error: $e');
      return null;
    }
  }
}
