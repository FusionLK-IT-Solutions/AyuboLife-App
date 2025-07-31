// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleSignInService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'https://www.googleapis.com/auth/fitness.activity.read',
//       'https://www.googleapis.com/auth/fitness.body.read',
//     ],
//   );
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser != null) {
//         final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//         final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         final UserCredential userCredential = await _auth.signInWithCredential(credential);
//         return userCredential.user;
//       }
//       return null;
//     } catch (e) {
//       print('Error signing in with Google: $e');
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//   }

//   Future<String?> getAccessToken() async {
//     try {
//       GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
      
//       if (googleUser == null) {
//         googleUser = await _googleSignIn.signInSilently();
//       }

//       if (googleUser != null) {
//         final googleAuth = await googleUser.authentication;
//         return googleAuth.accessToken;
//       }
//       return null;
//     } catch (e) {
//       print('Error getting access token: $e');
//       return null;
//     }
//   }
// }







import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/fitness.activity.read',
      'https://www.googleapis.com/auth/fitness.body.read',
    ],
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in using Google and Firebase Auth
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
      return null;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  /// Silent sign-in without user interaction
  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      print('Error signing in silently: $e');
      return null;
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  /// Get current access token for authenticated user
  Future<String?> getAccessToken() async {
    try {
      GoogleSignInAccount? googleUser = _googleSignIn.currentUser;

      if (googleUser == null) {
        googleUser = await _googleSignIn.signInSilently();
      }

      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        return googleAuth.accessToken;
      }

      return null;
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }
}
