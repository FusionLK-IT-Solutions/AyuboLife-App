import 'package:firebase_auth/firebase_auth.dart';
import 'package:ayubolife/data/models/user_model.dart';
import 'package:ayubolife/data/services/firebase_service.dart';
import 'package:ayubolife/data/services/google_sign_in_service.dart';

class AuthRepository {
  final FirebaseService _firebaseService = FirebaseService();
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  Future<UserModel?> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await _firebaseService.getUser(user.uid);
    }
    return null;
  }

  Future<UserModel?> signInWithGoogle() async {
    final user = await _googleSignInService.signInWithGoogle();
    if (user != null) {
      await _firebaseService.saveUserToFirestore(user);
      return await _firebaseService.getUser(user.uid);
    }
    return null;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignInService.signOut();
  }

  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();
}