import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_application/core/colors.dart';
import 'package:instagram_application/core/custombutton.dart';
import 'package:instagram_application/core/customtextform.dart';
import 'package:instagram_application/views/SignUp/cubit/signup_cubit.dart';

class Signup extends StatelessWidget {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController confirmpassordcontroller =
      TextEditingController();
  Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocProvider(
            create: (context) => SignupCubit(),
            child: BlocConsumer<SignupCubit, SignupState>(
              listener: (context, state) {
                if (state is SignupSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Signup Success'.tr()),
                    ),
                  );
                } else if (state is SignupError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset('assets/images/instagram.jpg'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    CustomTextForm(
                      controller: emailcontroller,
                      hinttext: 'Email'.tr(),
                      obsecure: false,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    CustomTextForm(
                      controller: passwordcontroller,
                      hinttext: 'Password'.tr(),
                      obsecure: true,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    CustomTextForm(
                        controller: confirmpassordcontroller,
                        hinttext: 'confirm password'.tr(),
                        obsecure: true),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    state is SignupLoading
                        ? CircularProgressIndicator()
                        : Custombutton(
                            onpress: () {
                              final email = emailcontroller.text.trim();
                              final password = passwordcontroller.text;

                              if (!email.contains('@') ||
                                  !email.contains('.')) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Invalid email format'.tr())),
                                );
                                return;
                              }

                              context
                                  .read<SignupCubit>()
                                  .signup(context, email, password);
                            },
                            text: 'Signup'.tr(),
                          ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
