import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ayubolife/data/models/google_fit_data_point.dart';

class GoogleFitService {
  static const String _baseUrl = 'https://www.googleapis.com/fitness/v1/users/me';

  Future<Map<String, dynamic>> getStepsData(String accessToken) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final startOfWeek = now.subtract(Duration(days: 6));
      final startOfMonth = DateTime(now.year, now.month, 1);

      final todaySteps = await _getStepsForPeriod(accessToken, startOfDay, now);
      final weeklySteps = await _getStepsForPeriod(accessToken, startOfWeek, now);
      final monthlySteps = await _getStepsForPeriod(accessToken, startOfMonth, now);

      return {
        'todaySteps': todaySteps,
        'weeklySteps': weeklySteps,
        'monthlySteps': monthlySteps,
        'lastSync': DateTime.now(),
      };
    } catch (e) {
      print('Error fetching Google Fit data: $e');
      return {
        'todaySteps': 0,
        'weeklySteps': 0,
        'monthlySteps': 0,
        'lastSync': DateTime.now(),
        'error': e.toString(),
      };
    }
  }

  Future<int> _getStepsForPeriod(String accessToken, DateTime startTime, DateTime endTime) async {
    final url = '$_baseUrl/dataset:aggregate';

    final body = {
      "aggregateBy": [
        {
          "dataTypeName": "com.google.step_count.delta",
          "dataSourceId": "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
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
      throw Exception('Failed to fetch steps data: ${response.statusCode}');
    }
  }

  Future<double> getCaloriesData(String accessToken) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final url = '$_baseUrl/dataset:aggregate';

      final body = {
        "aggregateBy": [
          {
            "dataTypeName": "com.google.calories.expended",
            "dataSourceId": "derived:com.google.calories.expended:com.google.android.gms:merge_calories_expended"
          }
        ],
        "bucketByTime": {"durationMillis": 86400000},
        "startTimeMillis": startOfDay.millisecondsSinceEpoch,
        "endTimeMillis": now.millisecondsSinceEpoch
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
        double totalCalories = 0.0;

        if (data['bucket'] != null) {
          for (var bucket in data['bucket']) {
            if (bucket['dataset'] != null && bucket['dataset'].isNotEmpty) {
              for (var dataset in bucket['dataset']) {
                if (dataset['point'] != null) {
                  for (var point in dataset['point']) {
                    if (point['value'] != null && point['value'].isNotEmpty) {
                      totalCalories += (point['value'][0]['fpVal'] ?? 0.0) as double;
                    }
                  }
                }
              }
            }
          }
        }
        return totalCalories;
      } else {
        throw Exception('Failed to fetch calories data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching calories data: $e');
      return 0.0;
    }
  }

  Future<List<GoogleFitDataPoint>> getWeeklyHistory(String accessToken) async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: 6));
      final url = '$_baseUrl/dataset:aggregate';

      final body = {
        "aggregateBy": [
          {
            "dataTypeName": "com.google.step_count.delta",
            "dataSourceId": "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
          }
        ],
        "bucketByTime": {"durationMillis": 86400000},
        "startTimeMillis": startOfWeek.millisecondsSinceEpoch,
        "endTimeMillis": now.millisecondsSinceEpoch
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
        List<GoogleFitDataPoint> history = [];

        if (data['bucket'] != null) {
          for (var bucket in data['bucket']) {
            int steps = 0;
            final startTimeMillis = int.parse(bucket['startTimeMillis']);
            final date = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);

            if (bucket['dataset'] != null && bucket['dataset'].isNotEmpty) {
              for (var dataset in bucket['dataset']) {
                if (dataset['point'] != null) {
                  for (var point in dataset['point']) {
                    if (point['value'] != null && point['value'].isNotEmpty) {
                      steps += (point['value'][0]['intVal'] ?? 0) as int;
                    }
                  }
                }
              }
            }
            history.add(GoogleFitDataPoint(date: date, steps: steps));
          }
        }
        return history;
      } else {
        throw Exception('Failed to fetch weekly history: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weekly history: $e');
      return [];
    }
  }
}