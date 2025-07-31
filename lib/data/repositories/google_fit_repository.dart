// import 'package:ayubolife/data/models/google_fit_data_point.dart';
// import 'package:ayubolife/data/services/google_fit_service.dart';
// import 'package:ayubolife/data/services/google_sign_in_service.dart';

// class GoogleFitRepository {
//   final GoogleFitService _googleFitService = GoogleFitService();
//   final GoogleSignInService _googleSignInService = GoogleSignInService();

//   Future<Map<String, dynamic>> getStepsData() async {
//     final accessToken = await _googleSignInService.getAccessToken();
//     if (accessToken != null) {
//       return await _googleFitService.getStepsData(accessToken);
//     }
//     return {
//       'todaySteps': 0,
//       'weeklySteps': 0,
//       'monthlySteps': 0,
//       'lastSync': DateTime.now(),
//     };
//   }

//   Future<double> getCaloriesData() async {
//     final accessToken = await _googleSignInService.getAccessToken();
//     if (accessToken != null) {
//       return await _googleFitService.getCaloriesData(accessToken);
//     }
//     return 0.0;
//   }

//   Future<List<GoogleFitDataPoint>> getWeeklyHistory() async {
//     final accessToken = await _googleSignInService.getAccessToken();
//     if (accessToken != null) {
//       return await _googleFitService.getWeeklyHistory(accessToken);
//     }
//     return [];
//   }
// }







import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:ayubolife/data/models/google_fit_data_point.dart';
import 'package:ayubolife/data/services/google_fit_service.dart';
import 'package:ayubolife/data/services/google_sign_in_service.dart';

class GoogleFitRepository {
  final GoogleFitService _googleFitService;
  final GoogleSignInService _googleSignInService;

  GoogleFitRepository({required GoogleSignInService googleSignInService})
      : _googleSignInService = googleSignInService,
        _googleFitService = GoogleFitService();

  /// Fetch today's, weekly, and monthly steps data with last sync
  Future<Map<String, dynamic>> getStepsData() async {
    final accessToken = await _googleSignInService.getAccessToken();
    if (accessToken != null) {
      return await _googleFitService.getStepsData(accessToken);
    }
    return {
      'todaySteps': 0,
      'weeklySteps': 0,
      'monthlySteps': 0,
      'lastSync': DateTime.now(),
    };
  }

  /// Fetch calories burned data
  Future<double> getCaloriesData() async {
    final accessToken = await _googleSignInService.getAccessToken();
    if (accessToken != null) {
      return await _googleFitService.getCaloriesData(accessToken);
    }
    return 0.0;
  }

  /// Get weekly history as a list of data points
  Future<List<GoogleFitDataPoint>> getWeeklyHistory() async {
    final accessToken = await _googleSignInService.getAccessToken();
    if (accessToken != null) {
      return await _googleFitService.getWeeklyHistory(accessToken);
    }
    return [];
  }

  /// Fetch steps from a given timestamp to now using Google Fit API
  Future<int> fetchSteps(Timestamp? joinedAt) async {
    if (joinedAt == null) return 0;

    try {
      final googleUser = await _googleSignInService.signInSilently();
      if (googleUser == null) {
        throw Exception('Google Sign-In failed');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      final startTime = joinedAt.toDate();
      final endTime = DateTime.now();
      final url = 'https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate';

      final body = {
        "aggregateBy": [
          {
            "dataTypeName": "com.google.step_count.delta",
            "dataSourceId":
                "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
          }
        ],
        "bucketByTime": {"durationMillis": 86400000},
        "startTimeMillis": startTime.millisecondsSinceEpoch,
        "endTimeMillis": endTime.millisecondsSinceEpoch
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        int totalSteps = 0;

        if (data['bucket'] != null) {
          for (var bucket in data['bucket']) {
            if (bucket['dataset'] != null && bucket['dataset'].isNotEmpty) {
              for (var dataset in bucket['dataset']) {
                if (dataset['point'] != null) {
                  for (var point in dataset['point']) {
                    if (point['value'] != null && point['value'].isNotEmpty) {
                      totalSteps += (point['value'][0]['intVal'] ?? 0) as int;
                    }
                  }
                }
              }
            }
          }
        }

        return totalSteps;
      } else {
        throw Exception('Failed to fetch steps: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching steps from Google Fit: $e');
    }
  }
}
