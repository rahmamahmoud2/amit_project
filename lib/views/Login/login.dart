import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_application/core/colors.dart';
import 'package:instagram_application/core/custombutton.dart';
import 'package:instagram_application/core/customtextform.dart';
import 'package:instagram_application/views/Login/cubit/login_cubit.dart';

class Login extends StatelessWidget {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocProvider(
          create: (context) => LoginCubit(),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.error),
                ));
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
                      obsecure: false,
                      hinttext: 'Email'.tr()),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  CustomTextForm(
                      controller: passwordcontroller,
                      obsecure: true,
                      hinttext: 'Password'.tr()),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  state is LoginLoading
                      ? CircularProgressIndicator()
                      : Custombutton(
                          text: 'Login'.tr(),
                          onpress: () {
                            final email = emailcontroller.text.trim();
                            final password = passwordcontroller.text;

                            if (!email.contains('@') || !email.contains('.')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Please enter a valid email address'
                                            .tr())),
                              );
                              return;
                            }

                            context
                                .read<LoginCubit>()
                                .login(context, email, password);
                          },
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dont have an account?'.tr(),
                        style: TextStyle(
                          fontFamily: 'inter',
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'signup');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                        ),
                        child: Text(
                          'Register'.tr(),
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(32, 32, 32, 1),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
