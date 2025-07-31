import 'dart:io';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final double? weight;
  final double? height;

  UpdateProfile({
    required this.firstName,
    required this.lastName,
    this.weight,
    this.height,
  });
}

class UpdateProfileImage extends ProfileEvent {
  final File imageFile;

  UpdateProfileImage({required this.imageFile});
}