import 'dart:async';
import 'package:ayubolife/data/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'programs_event.dart';
part 'programs_state.dart';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  final UserRepository _userRepository;

  ProgramsBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ProgramsInitial()) {
    on<LoadPrograms>(_onLoadPrograms);
    on<InitializeSamplePrograms>(_onInitializeSamplePrograms);
  }

  Future<void> _onLoadPrograms(LoadPrograms event, Emitter<ProgramsState> emit) async {
    emit(ProgramsLoading());
    try {
      final programs = await _userRepository.fetchPrograms();
      emit(ProgramsLoaded(
        recommendedPrograms: programs['recommended'] ?? [],
        healthOnlinePrograms: programs['health_online'] ?? [],
        managePrograms: programs['manage'] ?? [],
      ));
    } catch (e) {
      emit(ProgramsError('Failed to load programs: $e'));
    }
  }

 
  Future<void> _onInitializeSamplePrograms(
  InitializeSamplePrograms event,
  Emitter<ProgramsState> emit,
) async {
  emit(ProgramsLoading());

  try {
    final programs = await _userRepository.fetchPrograms();
    final joinedPrograms = await _userRepository.getJoinedProgramIds();

    emit(ProgramsLoaded(
      recommendedPrograms: programs['recommended'] ?? [],
      healthOnlinePrograms: programs['health_online'] ?? [],
      managePrograms: programs['manage'] ?? [],
      joinedPrograms: joinedPrograms.toSet(),
    ));
  } catch (e) {
    emit(ProgramsError('Failed to load programs'));
  }
}

}