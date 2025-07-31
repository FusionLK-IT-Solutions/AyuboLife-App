import 'dart:async';
import 'package:ayubolife/data/repositories/google_fit_repository.dart';
import 'package:ayubolife/data/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


part 'step_challenge_event.dart';
part 'step_challenge_state.dart';

class StepChallengeBloc extends Bloc<StepChallengeEvent, StepChallengeState> {
  final GoogleFitRepository _googleFitRepository;
  final UserRepository _userRepository;
  Timer? _updateTimer;

  StepChallengeBloc({
    required GoogleFitRepository googleFitRepository,
    required UserRepository userRepository,
  })  : _googleFitRepository = googleFitRepository,
        _userRepository = userRepository,
        super(StepChallengeInitial()) {
    on<InitializeStepChallenge>(_onInitializeStepChallenge);
    on<FetchSteps>(_onFetchSteps);
    on<UpdateProgress>(_onUpdateProgress);
    on<CollectTreasure>(_onCollectTreasure);
    on<RefreshStepChallenge>(_onRefreshStepChallenge);

    _setupUpdateTimer();
  }

  final List<LatLng> _routePoints = [
    LatLng(6.933950, 79.850870),
    LatLng(6.933120, 79.853660),
    // ... (include all route points from your original code)
    LatLng(7.293611, 80.641389),
  ];

  final double _totalRouteDistance = 116;

  final Map<int, Map<String, dynamic>> _treasures = {
    5000: {
      'gift': 'Free Toothbrush',
      'position': 0.1,
      'icon': BitmapDescriptor.hueRed,
      'description': 'Premium electric toothbrush',
    },
    10000: {
      'gift': 'Skin Cream',
      'position': 0.25,
      'icon': BitmapDescriptor.hueYellow,
      'description': 'Hydrating skin cream',
    },
    20000: {
      'gift': 'Fitness Band',
      'position': 0.5,
      'icon': BitmapDescriptor.hueGreen,
      'description': 'Smart fitness tracker',
    },
    50000: {
      'gift': 'Spa Voucher',
      'position': 0.9,
      'icon': BitmapDescriptor.hueMagenta,
      'description': 'Luxury spa treatment voucher',
    },
  };

  void _setupUpdateTimer() {
    _updateTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      add(FetchSteps());
      add(UpdateProgress());
    });
  }

  Future<void> _onInitializeStepChallenge(
    InitializeStepChallenge event,
    Emitter<StepChallengeState> emit,
  ) async {
    emit(StepChallengeLoading());
    try {
      await _requestPermissions();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final participantData = await _userRepository.getParticipantData(user.uid);
        final steps = await _googleFitRepository.fetchSteps(participantData['joinedAt']);
        final collectedTreasures = List<int>.from(participantData['collectedTreasures'] ?? []);
        final markers = await _buildMarkers(participantData['currentPosition']?.toDouble() ?? 0.0, steps, collectedTreasures);
        emit(StepChallengeLoaded(
          steps: steps,
          position: _calculatePosition(steps),
          collectedTreasures: collectedTreasures,
          markers: markers,
          polylines: _buildPolylines(),
        ));
      } else {
        emit(StepChallengeError('User not authenticated'));
      }
    } catch (e) {
      emit(StepChallengeError('Failed to initialize: $e'));
    }
  }

  Future<void> _onFetchSteps(FetchSteps event, Emitter<StepChallengeState> emit) async {
    if (state is StepChallengeLoaded) {
      emit((state as StepChallengeLoaded).copyWith(isLoading: true));
    }
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final participantData = await _userRepository.getParticipantData(user.uid);
        final steps = await _googleFitRepository.fetchSteps(participantData['joinedAt']);
        final collectedTreasures = List<int>.from(participantData['collectedTreasures'] ?? []);
        final markers = await _buildMarkers(participantData['currentPosition']?.toDouble() ?? 0.0, steps, collectedTreasures);
        emit(StepChallengeLoaded(
          steps: steps,
          position: _calculatePosition(steps),
          collectedTreasures: collectedTreasures,
          markers: markers,
          polylines: _buildPolylines(),
        ));
      }
    } catch (e) {
      emit(StepChallengeError('Failed to fetch steps: $e'));
    }
  }

  Future<void> _onUpdateProgress(UpdateProgress event, Emitter<StepChallengeState> emit) async {
    if (state is StepChallengeLoaded) {
      final currentState = state as StepChallengeLoaded;
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final position = _calculatePosition(currentState.steps);
          await _userRepository.updateParticipantProgress(
            user.uid,
            currentState.steps,
            position,
            currentState.collectedTreasures,
          );
          final markers = await _buildMarkers(position, currentState.steps, currentState.collectedTreasures);
          emit(currentState.copyWith(
            position: position,
            markers: markers,
          ));
        }
      } catch (e) {
        emit(StepChallengeError('Failed to update progress: $e'));
      }
    }
  }

  Future<void> _onCollectTreasure(CollectTreasure event, Emitter<StepChallengeState> emit) async {
    if (state is StepChallengeLoaded) {
      final currentState = state as StepChallengeLoaded;
      if (currentState.steps >= event.steps && !currentState.collectedTreasures.contains(event.steps)) {
        final newTreasures = List<int>.from(currentState.collectedTreasures)..add(event.steps);
        try {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await _userRepository.updateParticipantTreasures(user.uid, newTreasures);
            final markers = await _buildMarkers(currentState.position, currentState.steps, newTreasures);
            emit(currentState.copyWith(
              collectedTreasures: newTreasures,
              markers: markers,
            ));
          }
        } catch (e) {
          emit(StepChallengeError('Failed to collect treasure: $e'));
        }
      }
    }
  }

  Future<void> _onRefreshStepChallenge(RefreshStepChallenge event, Emitter<StepChallengeState> emit) async {
    emit(StepChallengeLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final participantData = await _userRepository.getParticipantData(user.uid);
        final steps = await _googleFitRepository.fetchSteps(participantData['joinedAt']);
        final collectedTreasures = List<int>.from(participantData['collectedTreasures'] ?? []);
        final markers = await _buildMarkers(participantData['currentPosition']?.toDouble() ?? 0.0, steps, collectedTreasures);
        emit(StepChallengeLoaded(
          steps: steps,
          position: _calculatePosition(steps),
          collectedTreasures: collectedTreasures,
          markers: markers,
          polylines: _buildPolylines(),
        ));
      }
    } catch (e) {
      emit(StepChallengeError('Failed to refresh: $e'));
    }
  }

  Future<void> _requestPermissions() async {
    // Implement permission request logic using your existing services
    // This can be moved to a service if needed
    await [
      Permission.activityRecognition,
      Permission.location,
    ].request();
  }

  double _calculatePosition(int steps) {
    final distanceWalked = (steps * 0.8) / 1000; // Assuming 0.8 meters per step
    return (distanceWalked / _totalRouteDistance * 100).clamp(0.0, 100.0);
  }

  LatLng _getPositionOnRoute(double percentage) {
    if (percentage <= 0) return _routePoints.first;
    if (percentage >= 100) return _routePoints.last;

    final segmentLength = 100.0 / (_routePoints.length - 1);
    final segmentIndex = (percentage / segmentLength).floor();
    final segmentProgress = (percentage % segmentLength) / segmentLength;

    if (segmentIndex >= _routePoints.length - 1) {
      return _routePoints.last;
    }

    final start = _routePoints[segmentIndex];
    final end = _routePoints[segmentIndex + 1];

    return LatLng(
      start.latitude + (end.latitude - start.latitude) * segmentProgress,
      start.longitude + (end.longitude - start.longitude) * segmentProgress,
    );
  }

  Future<Set<Marker>> _buildMarkers(double currentPosition, int steps, List<int> collectedTreasures) async {
    final participants = await FirebaseFirestore.instance
        .collection('games')
        .doc('HemasGame')
        .collection('participants')
        .get();

    Set<Marker> markers = {};

    for (var doc in participants.docs) {
      final data = doc.data();
      final position = data['currentPosition']?.toDouble() ?? 0.0;
      final userName = data['userName'] ?? 'Unknown';
      final isCurrentUser = doc.id == FirebaseAuth.instance.currentUser?.uid;

      final markerPosition = _getPositionOnRoute(position);

      markers.add(
        Marker(
          markerId: MarkerId(doc.id),
          position: markerPosition,
          infoWindow: InfoWindow(
            title: userName,
            snippet: '${data['totalSteps']} steps (${position.toStringAsFixed(1)}%)',
          ),
          icon: isCurrentUser
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    _treasures.forEach((stepsThreshold, treasure) {
      if (!collectedTreasures.contains(stepsThreshold)) {
        final position = _getPositionOnRoute(treasure['position'] * 100);
        final remainingSteps = stepsThreshold - steps;

        markers.add(
          Marker(
            markerId: MarkerId('treasure_$stepsThreshold'),
            position: position,
            icon: BitmapDescriptor.defaultMarkerWithHue(treasure['icon']),
            infoWindow: InfoWindow(
              title: treasure['gift'],
              snippet: remainingSteps > 0
                  ? '$remainingSteps steps remaining'
                  : 'Click to collect!',
            ),
            onTap: () {
              if (remainingSteps <= 0) {
                add(CollectTreasure(steps: stepsThreshold));
              }
            },
          ),
        );
      }
    });

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    return {
      Polyline(
        polylineId: PolylineId('route'),
        points: _routePoints,
        color: Colors.blue,
        width: 4,
      ),
    };
  }

  @override
  Future<void> close() {
    _updateTimer?.cancel();
    return super.close();
  }
}