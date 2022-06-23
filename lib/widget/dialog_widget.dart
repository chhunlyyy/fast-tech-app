import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:flutter/material.dart';

class DialogWidget {
  static void show(BuildContext context, String desc,
      {String btnCancelText = 'cancel', String btnOkText = 'ok', DialogType dialogType = DialogType.INFO, Function()? onOkPress, Function()? onCancelPress}) {
    AwesomeDialog(
      dismissOnTouchOutside: true,
      context: context,
      dialogType: dialogType,
      borderSide: BorderSide(color: ColorsConts.primaryColor, width: 2),
      width: MediaQuery.of(context).size.width,
      buttonsBorderRadius: const BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      desc: desc,
      showCloseIcon: false,
      btnCancelOnPress: onCancelPress,
      btnOkOnPress: onOkPress,
      btnCancelText: btnCancelText,
      btnOkText: btnOkText,
    ).show();
  }
}
