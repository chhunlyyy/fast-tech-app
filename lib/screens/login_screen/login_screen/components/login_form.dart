import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/user_model.dart';
import 'package:fast_tech_app/core/provider/cart_provider.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/helper/device_infor.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen.dart';
import 'package:fast_tech_app/screens/login_screen/components/rounded_input.dart';
import 'package:fast_tech_app/screens/login_screen/components/rounded_password_input.dart';
import 'package:fast_tech_app/services/order_service/order_service.dart';
import 'package:fast_tech_app/services/user_service/user_service.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:fast_tech_app/widget/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
    required this.fromAddToCart,
  }) : super(key: key);
  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;
  final bool fromAddToCart;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void getCart(int userId) {
    Future.delayed(Duration.zero, () async {
      await orderService.getProductInCart(userId).then(
        (value) {
          Provider.of<CartModelProvider>(context, listen: false).setCartModel(value);
        },
      );
    });
  }

  void _onLoginSuccess(UserModel userModel) {
    DialogWidget.show(context, I18NTranslations.of(context).text('login_success'), dialogType: DialogType.SUCCES);
    Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      TokenHelper.getInstance().setLogedIn(true);
      Provider.of<UserModelProvider>(context, listen: false).setUserModel(userModel);
      getCart(userModel.id);
      userService.checkAdmin(context, userModel.phone);
      if (widget.fromAddToCart) {
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        NavigationHelper.pushReplacement(
            context,
            const HomeScreen(
              dasboardEnum: DASBOARD_ENUM.user,
            ));
      }
    });
  }

  void _onLogin() {
    Future.delayed(Duration.zero, () async {
      if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
        DialogWidget.show(context, I18NTranslations.of(context).text('input_all_fields'), dialogType: DialogType.WARNING);
      } else {
        String token = await DeviceInfoHelper.getDivceId() ?? '';
        Map<String, dynamic> params = {'phone': _phoneController.text, 'password': _passwordController.text, 'token': token};
        await userService.login(params: params).then((value) {
          if (value['status'] == '200') {
            _onLoginSuccess(UserModel.fromJson(value['user']));
          } else {
            DialogWidget.show(context, I18NTranslations.of(context).text(value['status'].toString() == '422' ? 'wrong_username' : 'login_failt'),
                dialogType: value['status'].toString() == '422' ? DialogType.WARNING : DialogType.ERROR);
          }
        });
      }
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
