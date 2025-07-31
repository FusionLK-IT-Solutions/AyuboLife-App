import 'package:ayubolife/data/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final bool isUploadingImage;

  ProfileLoaded({
    required this.user,
    this.isUploadingImage = false,
  });

  ProfileLoaded copyWith({
    UserModel? user,
    bool? isUploadingImage,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
    );
  }
}

class ProfileUpdating extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}