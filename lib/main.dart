import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/i18n_model.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:fast_tech_app/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  TokenHelper.init(sharedPreferences, packageInfo);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => I18nModel())],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FastTechApp(),
      ),
    ),
  );
}

class FastTechApp extends StatelessWidget {
  const FastTechApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String langaugeCode = context.watch<I18nModel>().languageCode;
    return MaterialApp(
      home: const SplashScreen(),
      localizationsDelegates: const [
        I18NTranslations.delegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
        //provides localised for ios
        GlobalCupertinoLocalizations.delegate
      ],
      locale: const Locale('km'),
      supportedLocales: [Locale(langaugeCode)],
    );
  }
}
