import 'package:fast_tech_app/const/assets_const.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget emptyWidget({required BuildContext context}) {
  return Expanded(
    child: Center(
      child: Lottie.asset(AssetsConst.ANIM_LOTTIE_EMPTYBOX, height: MediaQuery.of(context).size.height / 4),
    ),
  );
}
