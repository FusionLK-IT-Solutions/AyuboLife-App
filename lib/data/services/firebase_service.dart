import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ayubolife/data/models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserToFirestore(User user) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      final displayName = user.displayName?.split(' ') ?? ['Unknown', ''];
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'firstName': displayName[0],
        'lastName': displayName.length > 1 ? displayName[1] : '',
        'photoURL': user.photoURL,
        'weight': null,
        'height': null,
        'credits': 5000,
        'createdAt': FieldValue.serverTimestamp(),
        'purchasedPrograms': [],
      });
    }
  }

  Future<UserModel?> getUser(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return UserModel.fromMap(userDoc.data()!);
    }
    return null;
  }

  Future<void> updateUser(
    String uid, {
    String? firstName,
    String? lastName,
    double? weight,
    double? height,
  }) async {
    final updates = <String, dynamic>{};
    if (firstName != null) updates['firstName'] = firstName;
    if (lastName != null) updates['lastName'] = lastName;
    if (weight != null) updates['weight'] = weight;
    if (height != null) updates['height'] = height;

    await _firestore.collection('users').doc(uid).update(updates);
  }
}