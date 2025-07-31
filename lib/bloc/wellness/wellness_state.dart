import 'package:ayubolife/data/models/user_model.dart';
import 'package:ayubolife/data/models/google_fit_data_point.dart';

abstract class WellnessState {}

class WellnessInitial extends WellnessState {}

class WellnessLoading extends WellnessState {}

class WellnessLoaded extends WellnessState {
  final UserModel user;
  final int stepsCount;
  final int weeklySteps;
  final int monthlySteps;
  final double caloriesCount;
  final DateTime lastSyncTime;
  final List<GoogleFitDataPoint> weeklyHistory;
  final String healthStatus;
  final bool isSyncing;

  WellnessLoaded({
    required this.user,
    required this.stepsCount,
    required this.weeklySteps,
    required this.monthlySteps,
    required this.caloriesCount,
    required this.lastSyncTime,
    required this.weeklyHistory,
    required this.healthStatus,
    this.isSyncing = false,
  });

  WellnessLoaded copyWith({
    UserModel? user,
    int? stepsCount,
    int? weeklySteps,
    int? monthlySteps,
    double? caloriesCount,
    DateTime? lastSyncTime,
    List<GoogleFitDataPoint>? weeklyHistory,
    String? healthStatus,
    bool? isSyncing,
  }) {
    return WellnessLoaded(
      user: user ?? this.user,
      stepsCount: stepsCount ?? this.stepsCount,
      weeklySteps: weeklySteps ?? this.weeklySteps,
      monthlySteps: monthlySteps ?? this.monthlySteps,
      caloriesCount: caloriesCount ?? this.caloriesCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      weeklyHistory: weeklyHistory ?? this.weeklyHistory,
      healthStatus: healthStatus ?? this.healthStatus,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

class WellnessError extends WellnessState {
  final String message;

  WellnessError({required this.message});
}