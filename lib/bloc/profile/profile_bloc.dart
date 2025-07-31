import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ayubolife/bloc/profile/profile_event.dart';
import 'package:ayubolife/bloc/profile/profile_state.dart';
import 'package:ayubolife/data/repositories/user_repository.dart';
import 'dart:io';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository;

  ProfileBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateProfileImage>(_onUpdateProfileImage);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await _userRepository.getCurrentUser();
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      emit(ProfileUpdating());
      try {
        await _userRepository.updateUserProfile(
          firstName: event.firstName,
          lastName: event.lastName,
          weight: event.weight,
          height: event.height,
        );
        final updatedUser = await _userRepository.getCurrentUser();
        emit(ProfileLoaded(user: updatedUser));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    }
  }

  void _onUpdateProfileImage(UpdateProfileImage event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isUploadingImage: true));
      
      try {
        // In a real implementation, you would upload the image to storage
        // and get the URL back, then update the user profile
        // For now, we'll just simulate this
        await Future.delayed(Duration(seconds: 2));
        emit(currentState.copyWith(isUploadingImage: false));
      } catch (e) {
        emit(ProfileError(message: e.toString()));
      }
    }
  }
}