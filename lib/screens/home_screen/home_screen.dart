import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/services/i18n_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _homeScreenWidget());
  }

  Widget _homeScreenWidget() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Center(child: Text(I18NTranslations.of(context).textLocale('កខគ', "abc"))),
            InkWell(
              onTap: () {
                I18nService.changeLanguage(context, 'km');
              },
              child: Container(width: 100, height: 20, color: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}
