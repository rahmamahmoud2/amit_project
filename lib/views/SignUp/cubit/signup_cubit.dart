import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_application/core/mainlayout.dart';
import 'package:instagram_application/views/completeProfile/complete_profile.dart';
import 'package:instagram_application/views/completeProfile/cubit/editprofile_cubit.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  Future<void> signup(
      BuildContext context, String email, String password) async {
    emit(SignupLoading());

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': '',
        'username': '',
        'bio': '',
        'phone': '',
        'gender': '',
        'imageUrl': '',
      });

      emit(SignupSuccess());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => ProfileCubit()..loadUserProfile(uid),
            child: Mainlayout(),
          ),
        ),
      );
    } catch (e) {
      emit(SignupError(e.toString()));
    }
  }
}
