// import 'package:ayubolife/data/models/user_model.dart';
// import 'package:ayubolife/data/services/firebase_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UserRepository {
//   final FirebaseService _firebaseService = FirebaseService();

//   Future<UserModel> getCurrentUser() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final userModel = await _firebaseService.getUser(user.uid);
//       if (userModel != null) {
//         return userModel;
//       }
//     }
//     throw Exception('User not found');
//   }

//   Future<void> updateUserProfile({
//     required String firstName,
//     required String lastName,
//     double? weight,
//     double? height,
//   }) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await _firebaseService.updateUser(
//         user.uid,
//         firstName: firstName,
//         lastName: lastName,
//         weight: weight,
//         height: height,
//       );
//     }
//   }
// }









import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ayubolife/data/models/user_model.dart';
import 'package:ayubolife/data/services/firebase_service.dart';

class UserRepository {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get current user from FirebaseAuth and fetch their data using FirebaseService
  Future<UserModel> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userModel = await _firebaseService.getUser(user.uid);
      if (userModel != null) {
        return userModel;
      }
    }
    throw Exception('User not found');
  }

  /// Update user's profile using FirebaseService
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    double? weight,
    double? height,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _firebaseService.updateUser(
        user.uid,
        firstName: firstName,
        lastName: lastName,
        weight: weight,
        height: height,
      );
    }
  }

  /// Get participant data from Firestore for a given userId or create if it doesn't exist
  Future<Map<String, dynamic>> getParticipantData(String userId) async {
    final doc = await _firestore
        .collection('games')
        .doc('HemasGame')
        .collection('participants')
        .doc(userId)
        .get();

    if (doc.exists) {
      return doc.data()!;
    } else {
      final user = FirebaseAuth.instance.currentUser;
      await _firestore
          .collection('games')
          .doc('HemasGame')
          .collection('participants')
          .doc(userId)
          .set({
        'userName': user?.displayName ?? 'Unknown',
        'joinedAt': FieldValue.serverTimestamp(),
        'totalSteps': 0,
        'currentPosition': 0.0,
        'collectedTreasures': [],
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return {
        'userName': user?.displayName ?? 'Unknown',
        'joinedAt': Timestamp.now(),
        'totalSteps': 0,
        'currentPosition': 0.0,
        'collectedTreasures': [],
      };
    }
  }

  /// Update participant progress including steps, position, and treasures
  Future<void> updateParticipantProgress(
    String userId,
    int steps,
    double position,
    List<int> collectedTreasures,
  ) async {
    await _firestore
        .collection('games')
        .doc('HemasGame')
        .collection('participants')
        .doc(userId)
        .update({
      'totalSteps': steps,
      'currentPosition': position,
      'collectedTreasures': collectedTreasures,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    // Update sharded leaderboard step counter
    final counterRef = _firestore
        .collection('games')
        .doc('HemasGame')
        .collection('leaderboard')
        .doc('stepCounter');

    final counterDoc = await counterRef.get();

    if (!counterDoc.exists) {
      await counterRef.set({'num_shards': 10});
      for (int i = 0; i < 10; i++) {
        await counterRef.collection('shards').doc(i.toString()).set({'count': 0});
      }
    }

    final shardId = (DateTime.now().millisecondsSinceEpoch % 10).toString();
    await counterRef.collection('shards').doc(shardId).update({
      'count': FieldValue.increment(steps),
    });
  }

  /// Update only collected treasures
  Future<void> updateParticipantTreasures(String userId, List<int> treasures) async {
    await _firestore
        .collection('games')
        .doc('HemasGame')
        .collection('participants')
        .doc(userId)
        .update({
      'collectedTreasures': treasures,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }


  Future<Map<String, List<Map<String, dynamic>>>> fetchPrograms() async {
    final recommendedDoc = await _firestore.collection('programs').doc('recommended').get();
    final healthOnlineDoc = await _firestore.collection('programs').doc('health_online').get();
    final manageDoc = await _firestore.collection('programs').doc('manage').get();

    return {
      'recommended': List<Map<String, dynamic>>.from(recommendedDoc.data()?['programs'] ?? []),
      'health_online': List<Map<String, dynamic>>.from(healthOnlineDoc.data()?['programs'] ?? []),
      'manage': List<Map<String, dynamic>>.from(manageDoc.data()?['programs'] ?? []),
    };
  }

  Future<void> createSamplePrograms() async {
    final recommendedRef = _firestore.collection('programs').doc('recommended');
    await recommendedRef.set({
      'programs': [
        {
          'id': 'hemas_step_challenge',
          'name': 'Hemas Step Challenge',
          'description': 'Transform your wellness journey',
          'rating': 4.5,
          'image': 'assets/images/Banner-6.jpg',
          'category': 'fitness',
        },
        {
          'id': 'myhealth',
          'name': 'myHealth',
          'description': 'Your family doctor is here',
          'rating': 4.8,
          'image': 'assets/images/myhealth.jpg',
          'category': 'health',
        },
        {
          'id': 'ayubolife_wellness',
          'name': 'AyuboLife Wellness',
          'description': 'Access to wellness programs',
          'rating': 4.2,
          'image': 'assets/images/ayubolife.jpg',
          'category': 'wellness',
        },
      ]
    });

    final healthOnlineRef = _firestore.collection('programs').doc('health_online');
    await healthOnlineRef.set({
      'programs': [
        {
          'id': 'channel_doctor',
          'name': 'Channel your Doctor',
          'description': 'Connect with healthcare professionals',
          'rating': 4.6,
          'image': 'assets/images/channel_doctor.jpg',
          'category': 'health',
        },
        {
          'id': 'lab_report',
          'name': 'Lab Report',
          'description': 'Get your reports delivered by an expert',
          'rating': 4.3,
          'image': 'assets/images/lab_report.jpg',
          'category': 'health',
        },
        {
          'id': 'ask_question',
          'name': 'Ask a Question',
          'description': 'Get answers to your health questions',
          'rating': 4.1,
          'image': 'assets/images/ask_question.jpg',
          'category': 'health',
        },
      ]
    });

    final manageRef = _firestore.collection('programs').doc('manage');
    await manageRef.set({
      'programs': [
        {
          'id': 'health_tracker',
          'name': 'Health Tracker',
          'description': 'Track your daily health metrics',
          'rating': 4.4,
          'image': 'assets/images/health_tracker.jpg',
          'category': 'health',
        },
        {
          'id': 'medication_reminder',
          'name': 'Medication Reminder',
          'description': 'Never miss your medications',
          'rating': 4.7,
          'image': 'assets/images/medication.jpg',
          'category': 'health',
        },
      ]
    });
  }

  /// Check if user is enrolled in a specific program
  Future<bool> isUserEnrolledInProgram(String programId, String userId) async {
    if (programId == 'hemas_step_challenge') {
      final participantData = await getParticipantData(userId);
      return participantData.isNotEmpty; // User is enrolled if participant data exists
    }
    // For other programs, check the user's enrolledPrograms array
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final enrolledPrograms = userDoc.data()?['enrolledPrograms'] as List<dynamic>? ?? [];
    return enrolledPrograms.contains(programId);
  }

  /// Enroll user in a program
  Future<void> enrollUserInProgram(String programId, String userId) async {
    if (programId == 'hemas_step_challenge') {
      // For Hemas Step Challenge, calling getParticipantData automatically enrolls the user
      await getParticipantData(userId);
    } else {
      // For other programs, update the enrolledPrograms array
      await _firestore.collection('users').doc(userId).update({
        'enrolledPrograms': FieldValue.arrayUnion([programId]),
      });
    }
  }













}
