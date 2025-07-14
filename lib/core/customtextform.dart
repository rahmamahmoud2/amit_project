import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:instagram_application/core/colors.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    super.key,
    required this.hinttext,
    required this.obsecure,
    required this.controller,
  });

  final hinttext;
  final obsecure;
  final controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecure,
      obscuringCharacter: "*",
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        fillColor: textfield,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: hinttext,
        hintStyle: TextStyle(color: loginfont, fontFamily: 'inter'),
      ),
    );
  }
}
