import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _homeScreenWidget());
  }

  Widget _homeScreenWidget() {
    return Container(
      child: Center(child: Text(I18NTranslations.of(context).textLocale('កខគ', "abc"))),
    );
  }
}
