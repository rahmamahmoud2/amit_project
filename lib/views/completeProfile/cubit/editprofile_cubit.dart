import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_application/core/cloud_services.dart';
import 'package:instagram_application/views/completeProfile/cubit/editprofile_state.dart';

class UserModel {
  final String uid;
  final String username;
  final String name;
  final String bio;
  final String email;
  final String phone;
  final String gender;
  final String imageUrl;

  UserModel({
    required this.uid,
    required this.username,
    required this.name,
    required this.bio,
    required this.email,
    required this.phone,
    required this.gender,
    required this.imageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'bio': bio,
      'email': email,
      'phone': phone,
      'gender': gender,
      'imageUrl': imageUrl,
    };
  }

  UserModel copyWith({
    String? username,
    String? name,
    String? bio,
    String? phone,
    String? gender,
    String? imageUrl,
  }) {
    return UserModel(
      uid: uid,
      username: username ?? this.username,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      email: email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  File? profileImage;

  Future<void> loadUserProfile(String uid) async {
    try {
      emit(ProfileLoading());

      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null) {
        final user = UserModel.fromMap(data);
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('المستخدم غير موجود'));
      }
    } catch (e) {
      emit(ProfileError('فشل تحميل البيانات: $e'));
    }
  }

  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage = File(picked.path);

      if (state is ProfileLoaded) {
        final currentUser = (state as ProfileLoaded).user;
        emit(ProfileLoaded(currentUser));
      }
    }
  }

  Future<String?> uploadImage(String uid) async {
    if (profileImage == null) return null;
    try {
      final cloudinary = CloudinaryService();
      final imageUrl = await cloudinary.uploadImage(profileImage!);
      print('✅ Cloudinary URL: $imageUrl');
      return imageUrl;
    } catch (e) {
      emit(ProfileError('Failed to upload image: ${e.toString()}'));
      return null;
    }
  }

  Future<void> updateProfile(UserModel user) async {
    emit(ProfileLoading());
    try {
      final imageUrl = await uploadImage(user.uid);
      final updatedUser = user.copyWith(imageUrl: imageUrl ?? user.imageUrl);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updatedUser.toMap());

      profileImage = null;
      await loadUserProfile(user.uid);
      if (!isClosed) emit(ProfileUpdated());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
