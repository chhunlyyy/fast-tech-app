import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyDataWidget {
  static Widget emptyDataWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Center(child: Text(I18NTranslations.of(context).text('no_data'), style: const TextStyle(color: Colors.red, fontSize: 24))),
          Lottie.asset(
            'assets/lottie/data-not-found.json',
          ),
        ],
      ),
    );
  }
}
