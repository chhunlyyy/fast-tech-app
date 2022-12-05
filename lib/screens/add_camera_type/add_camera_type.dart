import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/services/product_service/product_service.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:fast_tech_app/widget/dialog_widget.dart';
import 'package:flutter/material.dart';

import '../add_new_product_screen/add_new_product_screen.dart';

class AddCameraTypeScreen extends StatefulWidget {
  const AddCameraTypeScreen({Key? key}) : super(key: key);

  @override
  State<AddCameraTypeScreen> createState() => _AddCameraTypeScreenState();
}

class _AddCameraTypeScreenState extends State<AddCameraTypeScreen> {
  TextEditingController controller = TextEditingController();

  void _onSave() {
    if (controller.text.isNotEmpty) {
      Future.delayed(Duration.zero, () async {
        productService.insertCameraType(controller.text).then((val) {
          if (val == '200') {
            DialogWidget.show(
              context,
              I18NTranslations.of(context).text('insert_product_success'),
              dialogType: DialogType.SUCCES,
              onOkPress: () => NavigationHelper.pushReplacement(context, const AddNewProductScreen()),
              btnOkText: 'ok',
            );
          } else {
            DialogWidget.show(context, I18NTranslations.of(context).text('insert_product_unsuccess'), dialogType: DialogType.ERROR);
          }
        });
      });
    } else {
      DialogWidget.show(context, I18NTranslations.of(context).text('plz_insert_all_info'), dialogType: DialogType.WARNING);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorsConts.primaryColor),
          elevation: 0,
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          foregroundColor: ColorsConts.primaryColor,
          title: Text(I18NTranslations.of(context).text('add.camera.type')),
        ),
        body: Column(children: [
          const SizedBox(height: 20),
          _buildTextInput('camera.type', controller),
          const SizedBox(height: 20),
          _saveButton(),
        ]),
      ),
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomeAnimatedButton(
        width: MediaQuery.of(context).size.width,
        hegith: 50,
        title: I18NTranslations.of(context).text('save'),
        onTap: () {
          _onSave();
        },
        isShowShadow: true,
        backgroundColor: Colors.blue,
        radius: 5,
      ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController textEditingController,
      {bool isShowPercentage = false, bool enabled = true, TextInputType textInputType = TextInputType.text, Function(String)? onChange, double? width}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.grey.withOpacity(.2), borderRadius: BorderRadius.circular(5)),
          width: width ?? MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(10),
          child: TextFormField(
            enabled: enabled,
            keyboardType: textInputType,
            onChanged: onChange,
            maxLines: null,
            controller: textEditingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(.5),
              labelText: I18NTranslations.of(context).text(label) + ' ${isShowPercentage ? '%' : ''}',
              labelStyle: const TextStyle(color: Colors.grey),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffD98C00),
                ),
              ),
              contentPadding: const EdgeInsets.only(left: 10, top: 15, bottom: 15, right: 10),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
