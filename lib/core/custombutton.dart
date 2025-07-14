import 'package:flutter/material.dart';
import 'package:instagram_application/core/colors.dart';

class Custombutton extends StatelessWidget {
  const Custombutton({super.key, required this.text, required this.onpress});

  final text;
  final onpress;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            fixedSize: MaterialStatePropertyAll(Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.06)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
            backgroundColor:
                WidgetStatePropertyAll(Color.fromRGBO(0, 163, 255, 1))),
        onPressed: onpress,
        child: Text(
          text,
          style: TextStyle(color: white, fontFamily: 'inter'),
        ));
  }
}
