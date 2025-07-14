import 'dart:io';

import 'package:instagram_application/views/completeProfile/cubit/editprofile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}

class ProfileUpdated extends ProfileState {}

class ProfileImagePicked extends ProfileState {
  final File image;
  ProfileImagePicked(this.image);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
