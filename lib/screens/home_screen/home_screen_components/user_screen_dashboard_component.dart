import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/user_model.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/core/provider/user_role_provider.dart';
import 'package:fast_tech_app/helper/device_infor.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:fast_tech_app/screens/add_new_product_screen/add_new_product_screen.dart';
import 'package:fast_tech_app/screens/login_screen/login_screen/login.dart';
import 'package:fast_tech_app/screens/order_screen/ordering_screen.dart';
import 'package:fast_tech_app/screens/permission_setting_screen/permission_setting_screen.dart';
import 'package:fast_tech_app/screens/report/report_screen.dart';
import 'package:fast_tech_app/screens/report_as_summary/first_report_as_summary.dart';
import 'package:fast_tech_app/services/user_service/user_service.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class UserScreenDashboardComponent extends StatefulWidget {
  const UserScreenDashboardComponent({Key? key}) : super(key: key);

  @override
  State<UserScreenDashboardComponent> createState() => _UserScreenDashboardComponentState();
}

class _UserScreenDashboardComponentState extends State<UserScreenDashboardComponent> {
  late UserModel? _userModel;

  Future<void> _onLogout() async {
    TokenHelper.getInstance().setLogedIn(false);
    userService.logout(_userModel!.phone, await DeviceInfoHelper.getDivceId() ?? '');
    NavigationHelper.pushReplacement(
        context,
        const LoginScreen(
          fromLogout: true,
          fromAddToCart: false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModelProvider>(context).userModel;
    return Material(child: TokenHelper.getInstance().isLogedIn() && _userModel != null ? _userWidget() : _notYetLogInWidget());
  }

  Widget _userWidget() {
    return Expanded(
      child: Column(children: [
        const SizedBox(height: 20),
        _userNameWidget(),
        const SizedBox(height: 50),
        _line(),
        _buildBotton('is_buying', FontAwesomeIcons.spinner, Colors.blue, () => NavigationHelper.push(context, const OrderingScreen(index: 0))),
        // _buildBotton('done_buying', FontAwesomeIcons.check, Colors.green, () => NavigationHelper.push(context, const DoneOrderScreen())),
        context.watch<UserRoleProvider>().isSuperAdmin || context.watch<UserRoleProvider>().isAdmin
            ? _buildBotton('insert_product', FontAwesomeIcons.plus, Colors.brown, () => NavigationHelper.push(context, const AddNewProductScreen()))
            : const SizedBox.shrink(),
        context.watch<UserRoleProvider>().isSuperAdmin
            ? _buildBotton('permission_setting', FontAwesomeIcons.key, Colors.deepPurple, () => NavigationHelper.push(context, const PermissionSettingScreen()))
            : const SizedBox.shrink(),
        context.watch<UserRoleProvider>().isSuperAdmin
            ? _buildBotton('report', FontAwesomeIcons.bookOpen, Colors.deepOrange, () => NavigationHelper.push(context, const ReportScreen()))
            : const SizedBox.shrink(),
        context.watch<UserRoleProvider>().isSuperAdmin
            ? _buildBotton('report.summary', FontAwesomeIcons.bookOpen, Colors.deepOrange, () => NavigationHelper.push(context, const SummaryReport()))
            : const SizedBox.shrink(),
        const SizedBox(height: 50),
        _logoutButton(),
      ]),
    );
  }

  Widget _logoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomeAnimatedButton(
        title: I18NTranslations.of(context).text('logout'),
        onTap: _onLogout,
        isShowShadow: true,
        width: MediaQuery.of(context).size.width,
        hegith: 50,
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildBotton(String i18nString, IconData iconData, Color color, Function onTap) {
    return SizedBox(
      height: 70,
      child: Material(
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(
                    iconData,
                    color: color,
                  ),
                  const SizedBox(width: 30),
                  Text(
                    I18NTranslations.of(context).text(i18nString),
                    style: TextStyle(color: color),
                  ),
                  const Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ))),
                ],
              ),
              _line(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Colors.grey,
    );
  }

  Widget _userNameWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.2), spreadRadius: 2, blurRadius: 4)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(_userModel!.name),
          Text(
            I18NTranslations.of(context).text('phone_number') + '\t' + _userModel!.phone,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
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
            onTap: () => NavigationHelper.push(
                context,
                const LoginScreen(
                  fromLogout: false,
                  fromAddToCart: false,
                )),
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
