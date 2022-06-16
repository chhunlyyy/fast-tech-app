import 'package:fast_tech_app/screens/login_screen/components/input_container.dart';
import 'package:fast_tech_app/screens/login_screen/constants.dart';
import 'package:flutter/material.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({Key? key, required this.hint, required this.controller}) : super(key: key);

  final String hint;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextField(
      controller: controller,
      cursorColor: kPrimaryColor,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.lock, color: kPrimaryColor),
        hintText: hint,
        border: InputBorder.none,
      ),
    ));
  }
}
