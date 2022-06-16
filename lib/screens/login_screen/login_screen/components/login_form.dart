import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/screens/login_screen/components/rounded_input.dart';
import 'package:fast_tech_app/screens/login_screen/components/rounded_password_input.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);
  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onLogin() {
    Future.delayed(Duration.zero, () async {
      if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 1.0 : 0.0,
      duration: widget.animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: widget.size.width,
          height: widget.defaultLoginSize,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 10),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Lottie.asset('assets/lottie/login-lottie.json'),
                ),
                RoundedInput(
                  isPhoneInput: true,
                  icon: Icons.phone,
                  hint: I18NTranslations.of(context).text('phone_number'),
                  textEditingController: _phoneController,
                ),
                RoundedPasswordInput(
                  hint: I18NTranslations.of(context).text('password'),
                  controller: _passwordController,
                ),
                const SizedBox(height: 10),
                CustomeAnimatedButton(
                  isShowShadow: true,
                  backgroundColor: ColorsConts.primaryColor,
                  width: MediaQuery.of(context).size.width * .8,
                  hegith: 55,
                  title: I18NTranslations.of(context).text('login'),
                  onTap: _onLogin,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
