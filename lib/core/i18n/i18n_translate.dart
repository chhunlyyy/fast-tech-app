import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> languageSupport = ['en', 'km'];

typedef TranslateType = String Function(String key, [Map<String, String> options]);

// I18n Localizations I18NTranslations
class I18NTranslations {
  static RegExp exp = RegExp(r"\{(.*?)\}");

  // localization variables
  final Locale locale;

  Map<String, String> localizedStrings = {};

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<I18NTranslations> delegate = _I18NTranslationsDelegate();

  I18NTranslations(this.locale);

  static I18NTranslations of(BuildContext context) {
    return Localizations.of<I18NTranslations>(context, I18NTranslations)!;
  }

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString().replaceAll(r"\'", "'").replaceAll(r"\t", " "));
    });

    return true;
  }

  static String replace(txt, [Map<String, String>? options]) {
    return txt.replaceAllMapped(exp, (Match m) {
      if (options == null || options.isEmpty) return m.group(0) ?? '';
      if (m.group(0) == null || m.group(1) == null) return '';
      return options[m.group(1)] ?? m.group(0) ?? '';
    });
  }

  String translate(String key, [Map<String, String>? options]) {
    String txt = localizedStrings[key] ?? key;
    if (options == null || options.isEmpty) return txt;
    return replace(txt, options);
  }

  String text(String key, [Map<String, String>? options]) {
    return translate(key, options);
  }

  String textLocale(String? text, String? textEn) {
    if (locale.languageCode != 'en') {
      if (text == null || text.trim().isEmpty) {
        return textEn ?? "";
      } else {
        return text;
      }
    } else {
      if (textEn == null || textEn.trim().isEmpty) {
        return text ?? "";
      } else {
        return textEn;
      }
    }
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an I18NTranslations object
class _I18NTranslationsDelegate extends LocalizationsDelegate<I18NTranslations> {
  // ignore: non_constant_identifier_names
  final String TAG = "I18NTranslations";

  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _I18NTranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return languageSupport.contains(locale.languageCode);
  }

  @override
  Future<I18NTranslations> load(Locale locale) async {
    // I18NTranslations class is where the JSON loading actually runs
    I18NTranslations localizations = I18NTranslations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_I18NTranslationsDelegate old) => false;
}
