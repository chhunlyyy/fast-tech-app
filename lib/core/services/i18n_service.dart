import 'package:fast_tech_app/core/provider/i18n_provider.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class I18nService {
  static void changeLanguage(BuildContext context, String languageCode) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<I18nProvider>().setLanguageCode(languageCode);
    });
    TokenHelper.getInstance().setLanguageCode(languageCode);
  }
}
