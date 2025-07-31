part of 'step_challenge_bloc.dart';

abstract class StepChallengeEvent extends Equatable {
  const StepChallengeEvent();

  @override
  List<Object> get props => [];
}

class InitializeStepChallenge extends StepChallengeEvent {}

class FetchSteps extends StepChallengeEvent {}

class UpdateProgress extends StepChallengeEvent {}

class CollectTreasure extends StepChallengeEvent {
  final int steps;

  const CollectTreasure({required this.steps});

  @override
  List<Object> get props => [steps];
}

class RefreshStepChallenge extends StepChallengeEvent {}