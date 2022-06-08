import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/core/services/i18n_service.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:fast_tech_app/screens/choose_language_screen/top_bar.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChooseLanguageScreen extends StatefulWidget {
  final bool hasContext;
  const ChooseLanguageScreen({Key? key, required this.hasContext}) : super(key: key);

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  void _onChoose(bool isKhmer) {
    Future.delayed(Duration.zero, () async {
      TokenHelper.getInstance().setLogin();
      TokenHelper.getInstance().setLanguageCode(isKhmer ? 'km' : 'en');
      I18nService.changeLanguage(context, isKhmer ? 'km' : 'en');
      NavigationHelper.pushReplacement(context, const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        TopBar(),
        _backButton(),
        Column(
          children: [
            const SizedBox(height: 50),
            const SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _animationWidget(context),
                      _bodyWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _animationWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4.5),
      child: Lottie.asset('assets/lottie/about-us.json'),
    );
  }

  Widget _bodyWidget() {
    return SizedBox(
      child: Column(children: [
        _buidlButton(true),
        _buidlButton(false),
      ]),
    );
  }

  Widget _buidlButton(bool isKhmer) {
    return Container(
      width: double.infinity,
      height: 100,
      color: isKhmer ? Colors.red.shade300 : const Color.fromARGB(255, 37, 51, 113).withOpacity(.8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (() => _onChoose(isKhmer)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isKhmer ? AssetsConst.CAMBODAI_FLAG : AssetsConst.UNITEDK_INDOM_FLAG,
                width: 55,
                height: 35,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 50),
              Text(
                isKhmer ? "ភាសាខ្មែរ" : "English",
                style: const TextStyle(color: Colors.white, fontSize: 25),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return widget.hasContext
        ? Positioned(
            top: 50,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
