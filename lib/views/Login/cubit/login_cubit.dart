import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_application/core/mainlayout.dart';
import 'package:instagram_application/views/completeProfile/complete_profile.dart';
import 'package:instagram_application/views/completeProfile/cubit/editprofile_cubit.dart';
import 'package:instagram_application/views/home/home.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(
      BuildContext context, String email, String password) async {
    emit(LoginLoading());

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(LoginSuccess());

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProfileCubit()
              ..loadUserProfile(FirebaseAuth.instance.currentUser!.uid),
            child: Mainlayout(),
          ),
        ),
      );
    } catch (e) {
      emit(LoginError(error: e.toString()));
    }
  }
}
