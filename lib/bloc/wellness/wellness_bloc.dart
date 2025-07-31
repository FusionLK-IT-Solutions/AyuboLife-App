import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayubolife/bloc/wellness/wellness_event.dart';
import 'package:ayubolife/bloc/wellness/wellness_state.dart';
import 'package:ayubolife/data/repositories/user_repository.dart';
import 'package:ayubolife/data/repositories/google_fit_repository.dart';

class WellnessBloc extends Bloc<WellnessEvent, WellnessState> {
  final UserRepository _userRepository;
  final GoogleFitRepository _googleFitRepository;

  WellnessBloc({
    required UserRepository userRepository,
    required GoogleFitRepository googleFitRepository,
  })  : _userRepository = userRepository,
        _googleFitRepository = googleFitRepository,
        super(WellnessInitial()) {
    on<LoadWellnessData>(_onLoadWellnessData);
    on<SyncGoogleFitData>(_onSyncGoogleFitData);
    on<RefreshWellnessData>(_onRefreshWellnessData);
  }

  void _onLoadWellnessData(LoadWellnessData event, Emitter<WellnessState> emit) async {
    emit(WellnessLoading());
    try {
      final user = await _userRepository.getCurrentUser();
      final googleFitData = await _googleFitRepository.getStepsData();
      final caloriesData = await _googleFitRepository.getCaloriesData();
      final weeklyHistory = await _googleFitRepository.getWeeklyHistory();

      emit(WellnessLoaded(
        user: user,
        stepsCount: googleFitData['todaySteps'] ?? 0,
        weeklySteps: googleFitData['weeklySteps'] ?? 0,
        monthlySteps: googleFitData['monthlySteps'] ?? 0,
        caloriesCount: caloriesData,
        lastSyncTime: googleFitData['lastSync'] ?? DateTime.now(),
        weeklyHistory: weeklyHistory,
        healthStatus: googleFitData['todaySteps'] > 0 
            ? 'Data synced successfully from Google Fit'
            : 'No step data found in Google Fit',
      ));
    } catch (e) {
      emit(WellnessError(message: e.toString()));
    }
  }

  void _onSyncGoogleFitData(SyncGoogleFitData event, Emitter<WellnessState> emit) async {
    if (state is WellnessLoaded) {
      final currentState = state as WellnessLoaded;
      emit(currentState.copyWith(isSyncing: true));
      
      try {
        final googleFitData = await _googleFitRepository.getStepsData();
        final caloriesData = await _googleFitRepository.getCaloriesData();
        final weeklyHistory = await _googleFitRepository.getWeeklyHistory();

        emit(currentState.copyWith(
          stepsCount: googleFitData['todaySteps'] ?? 0,
          weeklySteps: googleFitData['weeklySteps'] ?? 0,
          monthlySteps: googleFitData['monthlySteps'] ?? 0,
          caloriesCount: caloriesData,
          lastSyncTime: DateTime.now(),
          weeklyHistory: weeklyHistory,
          healthStatus: googleFitData['todaySteps'] > 0 
              ? 'Google Fit data synced successfully!'
              : 'No new data found in Google Fit',
          isSyncing: false,
        ));
      } catch (e) {
        emit(currentState.copyWith(
          isSyncing: false,
          healthStatus: 'Error syncing with Google Fit: ${e.toString()}',
        ));
      }
    }
  }

  void _onRefreshWellnessData(RefreshWellnessData event, Emitter<WellnessState> emit) async {
    add(LoadWellnessData());
  }
}