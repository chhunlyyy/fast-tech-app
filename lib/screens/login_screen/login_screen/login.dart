import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/screens/login_screen/constants.dart';
import 'package:fast_tech_app/screens/login_screen/login_screen/components/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/cancel_button.dart';
import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  final bool fromLogout;
  const LoginScreen({required this.fromLogout});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = const Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    animationController = AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset = MediaQuery.of(context).viewInsets.bottom; // we are using this to determine Keyboard is opened or not
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize = Tween<double>(begin: size.height * 0.1, end: defaultRegisterSize).animate(CurvedAnimation(parent: animationController, curve: Curves.linear));

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              // Lets add some decorations
              Positioned(
                  top: 100,
                  right: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: kPrimaryColor),
                  )),

              Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    child: !widget.fromLogout
                        ? Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: kPrimaryColor),
                  )),

              // Cancel Button

              Visibility(
                visible: !isLogin,
                child: CancelButton(
                  isLogin: isLogin,
                  animationDuration: animationDuration,
                  size: size,
                  animationController: animationController,
                  tapEvent: isLogin
                      ? () {}
                      : () {
                          // returning null to disable the button
                          animationController.reverse();
                          if (mounted) {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          }
                        },
                ),
              ),

              // Login Form
              LoginForm(
                isLogin: isLogin,
                animationDuration: animationDuration,
                size: size,
                defaultLoginSize: defaultLoginSize,
              ),

              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  if (viewInset == 0 && isLogin) {
                    return buildRegisterContainer();
                  } else if (!isLogin) {
                    return buildRegisterContainer();
                  }

                  // Returning empty container to hide the widget
                  return Container();
                },
              ),

              RegisterForm(isLogin: isLogin, animationDuration: animationDuration, size: size, defaultLoginSize: defaultRegisterSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            color: Color(0xffF0F1F5)),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin
              ? null
              : () {
                  animationController.forward();

                  if (mounted) {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  }
                },
          child: isLogin
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      I18NTranslations.of(context).text('dont_have_account_yet'),
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      I18NTranslations.of(context).text('click_here'),
                      style: TextStyle(color: kPrimaryColor, fontSize: 18),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
