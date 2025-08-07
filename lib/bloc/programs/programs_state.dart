part of 'programs_bloc.dart';

abstract class ProgramsState extends Equatable {
  const ProgramsState();

  @override
  List<Object> get props => [];
}

class ProgramsInitial extends ProgramsState {}

class ProgramsLoading extends ProgramsState {}

class ProgramsLoaded extends ProgramsState {
  final List<Map<String, dynamic>> recommendedPrograms;
  final List<Map<String, dynamic>> healthOnlinePrograms;
  final List<Map<String, dynamic>> managePrograms;
  final Set<String> joinedPrograms; 

  const ProgramsLoaded({
    required this.recommendedPrograms,
    required this.healthOnlinePrograms,
    required this.managePrograms,
    this.joinedPrograms = const {}, 
  });

  @override
  List<Object> get props => [recommendedPrograms, healthOnlinePrograms, managePrograms];
}

class ProgramsError extends ProgramsState {
  final String message;

  const ProgramsError(this.message);

  @override
  List<Object> get props => [message];
}