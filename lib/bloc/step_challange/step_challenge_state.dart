part of 'step_challenge_bloc.dart';

abstract class StepChallengeState extends Equatable {
  const StepChallengeState();

  @override
  List<Object> get props => [];
}

class StepChallengeInitial extends StepChallengeState {}

class StepChallengeLoading extends StepChallengeState {}

class StepChallengeLoaded extends StepChallengeState {
  final int steps;
  final double position;
  final List<int> collectedTreasures;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final bool isLoading;

  const StepChallengeLoaded({
    required this.steps,
    required this.position,
    required this.collectedTreasures,
    required this.markers,
    required this.polylines,
    this.isLoading = false,
  });

  StepChallengeLoaded copyWith({
    int? steps,
    double? position,
    List<int>? collectedTreasures,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    bool? isLoading,
  }) {
    return StepChallengeLoaded(
      steps: steps ?? this.steps,
      position: position ?? this.position,
      collectedTreasures: collectedTreasures ?? this.collectedTreasures,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [steps, position, collectedTreasures, markers, polylines, isLoading];
}

class StepChallengeError extends StepChallengeState {
  final String message;

  const StepChallengeError(this.message);

  @override
  List<Object> get props => [message];
}