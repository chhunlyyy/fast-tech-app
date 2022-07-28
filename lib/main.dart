import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/provider/cart_provider.dart';
import 'package:fast_tech_app/core/provider/delivery_order_provider.dart';
import 'package:fast_tech_app/core/provider/i18n_provider.dart';
import 'package:fast_tech_app/core/provider/package_order_provider.dart';
import 'package:fast_tech_app/core/provider/pickup_order_provider.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/core/provider/user_role_provider.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:fast_tech_app/screens/splash_screen/splash_screen.dart';
import 'package:fast_tech_app/services/firebase_service/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  ///
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  await Firebase.initializeApp();

  TokenHelper.init(sharedPreferences, packageInfo);

  // disable rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => I18nProvider()),
        ChangeNotifierProvider(create: (_) => UserModelProvider()),
        ChangeNotifierProvider(create: (_) => CartModelProvider()),
        ChangeNotifierProvider(create: (_) => PickupOrderModelProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryOrderModelProvider()),
        ChangeNotifierProvider(create: (_) => PackageOrderModelProvider()),
        ChangeNotifierProvider(create: (_) => UserRoleProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FastTechApp(),
      ),
    ),
  );
}

class FastTechApp extends StatefulWidget {
  const FastTechApp({Key? key}) : super(key: key);

  @override
  State<FastTechApp> createState() => _FastTechAppState();
}

class _FastTechAppState extends State<FastTechApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firebaseNotifications.setUpFirebase(context);
    firebaseNotifications.subscribeTopic('fasttech');
  }

  @override
  Widget build(BuildContext context) {
    String langaugeCode = context.watch<I18nProvider>().languageCode;

    return GestureDetector(
      onTap: (() => FocusManager.instance.primaryFocus?.unfocus()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
      ),
    );
  }
}
