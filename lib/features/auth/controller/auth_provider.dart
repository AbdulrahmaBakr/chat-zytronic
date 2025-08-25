import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> init() async {
    _auth.userChanges().listen((User? u) {
      user = u;
      notifyListeners();
    });

    if (_auth.currentUser == null) {
      await signInAnonymously();
    } else {
      user = _auth.currentUser;
      notifyListeners();
    }
  }

  Future<void> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      user = credential.user;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error in signInAnonymously: $e");
      }
    }
  }

  /// Email & Password Sign-In
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = credential.user;
      notifyListeners();
      return user;
    } catch (e) {
      if (kDebugMode) {
        print("Error in signInWithEmail: $e");
      }
      return null;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;
  String get userId => user?.uid ?? "";
}
