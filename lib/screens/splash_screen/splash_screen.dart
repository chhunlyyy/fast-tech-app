import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/models/i18n_model.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:fast_tech_app/screens/choose_language_screen/choose_language_screen.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //
  void _navigation() {
    Future.delayed(const Duration(seconds: 2)).whenComplete(() => {
          if (TokenHelper.getInstance().isFirstLogin())
            {
              NavigationHelper.pushReplacement(
                context,
                const ChooseLanguageScreen(
                  hasContext: false,
                ),
              )
            }
          else
            {
              Future.delayed(Duration.zero, () {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  context.read<I18nModel>().setLanguageCode(TokenHelper.getInstance().getLanguageCode);
                });
              }).whenComplete(() => NavigationHelper.pushReplacement(
                    context,
                    const HomeScreen(),
                  ))
            }
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _splashScreenBody(),
    );
  }

  Widget _splashScreenBody() {
    _navigation();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: ColorsConts.primaryColor,
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => ScaleAnimation(
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
