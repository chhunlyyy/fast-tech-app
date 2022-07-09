import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/user_model.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/helper/device_infor.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen.dart';
import 'package:fast_tech_app/screens/login_screen/components/rounded_input.dart';
import 'package:fast_tech_app/screens/login_screen/components/rounded_password_input.dart';
import 'package:fast_tech_app/services/user_service/user_service.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:fast_tech_app/widget/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
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
  Widget build(BuildContext context) {
    //
    TextEditingController _phoneController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    //

    void _onReisterSuccess(UserModel userModel) {
      DialogWidget.show(context, I18NTranslations.of(context).text('success_register'), dialogType: DialogType.SUCCES);
      Future.delayed(const Duration(seconds: 2)).whenComplete(() {
        TokenHelper.getInstance().setLogedIn(true);
        Provider.of<UserModelProvider>(context, listen: false).setUserModel(userModel);
        userService.checkAdmin(userModel.phone);
        NavigationHelper.pushReplacement(
            context,
            const HomeScreen(
              dasboardEnum: DASBOARD_ENUM.user,
            ));
      });
    }

    void _onRegister() {
      if (_phoneController.text.isEmpty || _nameController.text.isEmpty || _passwordController.text.isEmpty) {
        DialogWidget.show(context, I18NTranslations.of(context).text('input_all_fields'), dialogType: DialogType.WARNING);
      } else {
        Future.delayed(Duration.zero, () async {
          String token = await DeviceInfoHelper.getDivceId();
          Map<String, dynamic> params = {
            'name': _nameController.text,
            'phone': _phoneController.text,
            'password': _passwordController.text,
            'token': token,
          };
          await userService.register(params: params).then(((value) {
            if (value['status'].toString() == '200') {
              _onReisterSuccess(UserModel.fromJson(value['user']));
            } else {
              DialogWidget.show(context, I18NTranslations.of(context).text(value['status'].toString() == '422' ? 'phone_used' : 'problem_regiseter'),
                  dialogType: value['status'].toString() == '422' ? DialogType.WARNING : DialogType.ERROR);
            }
          }));
        });
      }
    }

    return AnimatedOpacity(
      opacity: isLogin ? 0.0 : 1.0,
      duration: animationDuration * 5,
      child: Visibility(
        visible: !isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: size.width,
            height: defaultLoginSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'បង្កើតគណនីថ្មី',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Lottie.asset('assets/lottie/register-lottie.json'),
                  ),
                  RoundedInput(
                    isPhoneInput: true,
                    icon: Icons.phone,
                    hint: I18NTranslations.of(context).text('phone_number'),
                    textEditingController: _phoneController,
                  ),
                  RoundedInput(isPhoneInput: false, icon: Icons.face_rounded, hint: I18NTranslations.of(context).text('user_name'), textEditingController: _nameController),
                  RoundedPasswordInput(hint: I18NTranslations.of(context).text('password'), controller: _passwordController),
                  const SizedBox(height: 10),
                  CustomeAnimatedButton(
                    isShowShadow: true,
                    backgroundColor: ColorsConts.primaryColor,
                    width: MediaQuery.of(context).size.width * .8,
                    hegith: 55,
                    title: I18NTranslations.of(context).text('create'),
                    onTap: _onRegister,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
