import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:instagram_application/core/mainlayout.dart';
import 'package:instagram_application/views/Login/login.dart';
import 'package:instagram_application/views/SignUp/signup.dart';
import 'package:instagram_application/views/addPost/post_details.dart';
import 'package:instagram_application/views/completeProfile/complete_profile.dart';
import 'package:instagram_application/views/explore/ExploreScreen.dart';
import 'package:instagram_application/views/likes/likes.dart';
import 'package:instagram_application/views/profile/profile.dart';
import 'package:instagram_application/core/theme/cubit/theme_cubit.dart';
import 'package:instagram_application/core/theme/cubit/theme_state.dart';
import 'package:instagram_application/core/theme/themes.dart';
import 'package:instagram_application/views/reels/reels.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state.mode,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          initialRoute: 'login',
          routes: {
            'signup': (context) => Signup(),
            'login': (context) => Login(),
            'editProfile': (context) => EditProfileScreen(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                ),
            'mainLayout': (context) => const Mainlayout(),
            'profile': (context) => const ProfileScreen(),
            'postDetails': (context) {
              final data = ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
              return PostDetailsScreen(postData: data);
            },
            'explore': (context) => const ExploreScreen(),
            'reels': (context) => const ReelsScreen(),
            'likes': (context) => NotificationsPage(),
          },
        );
      },
    );
  }
}
