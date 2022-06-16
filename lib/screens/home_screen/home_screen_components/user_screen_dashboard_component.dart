import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/user_model.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:fast_tech_app/screens/login_screen/login_screen/login.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class UserScreenDashboardComponent extends StatefulWidget {
  const UserScreenDashboardComponent({Key? key}) : super(key: key);

  @override
  State<UserScreenDashboardComponent> createState() => _UserScreenDashboardComponentState();
}

class _UserScreenDashboardComponentState extends State<UserScreenDashboardComponent> {
  late UserModel? _userModel;

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModelProvider>(context).userModel;
    return TokenHelper.getInstance().isLogedIn() ? _userWidget() : _notYetLogInWidget();
  }

  Widget _userWidget() {
    return Container(
      child: Text(_userModel!.name),
    );
  }

  Widget _notYetLogInWidget() {
    return Expanded(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            I18NTranslations.of(context).text('please_log_in'),
            style: const TextStyle(fontSize: 20, color: Colors.blue),
          ),
          const SizedBox(height: 20),
          Lottie.asset(
            AssetsConst.USER_LOGIN_LOTTIE,
          ),
          const SizedBox(height: 40),
          CustomeAnimatedButton(
            title: I18NTranslations.of(context).text('to_login_screen'),
            onTap: () => NavigationHelper.push(context, const LoginScreen()),
            isShowShadow: true,
            backgroundColor: Colors.blue,
            width: MediaQuery.of(context).size.width / 1.5,
            hegith: 50,
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 8),
        ],
      ),
    ));
  }
}
