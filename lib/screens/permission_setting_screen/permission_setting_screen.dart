import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/user_model.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/services/user_service/user_service.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:fast_tech_app/widget/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PermissionSettingScreen extends StatefulWidget {
  const PermissionSettingScreen({Key? key}) : super(key: key);

  @override
  State<PermissionSettingScreen> createState() => _PermissionSettingScreenState();
}

class _PermissionSettingScreenState extends State<PermissionSettingScreen> {
  late Size _size;

  List<UserModel> _adminUserList = [];

  late UserModel _userModel;

  final TextEditingController _editingController = TextEditingController();

  void _getAdminUser() async {
    await userService.getAllAdminUser().then((value) {
      setState(() {
        _adminUserList = value;
      });
    });
  }

  void _onDeleteRole(String phone) {
    if (phone != _userModel.phone) {
      userService.deleteRole(phone).then((value) {
        if (value == '200') {
          DialogWidget.show(context, I18NTranslations.of(context).text('success_delete_role'), dialogType: DialogType.SUCCES);
        } else {
          DialogWidget.show(context, I18NTranslations.of(context).text('unsuccess_delete_role'), dialogType: DialogType.ERROR);
        }

        _getAdminUser();
      });
    } else {
      DialogWidget.show(context, I18NTranslations.of(context).text('can_not_delete_your_self'), dialogType: DialogType.WARNING);
    }
  }

  void _onAddRole(bool isSuperAdmin) {
    bool condition = true;

    for (var element in _adminUserList) {
      if (_editingController.text == element.phone) {
        condition = false;
      }
    }
    if (condition) {
      userService.addRole(_editingController.text, isSuperAdmin ? '0' : '1').then((value) {
        if (value == '200') {
          DialogWidget.show(context, I18NTranslations.of(context).text('success_added_role'), dialogType: DialogType.SUCCES);
        } else if (value == '400') {
          DialogWidget.show(context, I18NTranslations.of(context).text('phone_not_in_system'), dialogType: DialogType.WARNING);
        } else {
          DialogWidget.show(context, I18NTranslations.of(context).text('unsuccess_added_role'), dialogType: DialogType.ERROR);
        }

        _getAdminUser();
      });
    } else {
      DialogWidget.show(context, I18NTranslations.of(context).text('phone_already_admin'), dialogType: DialogType.WARNING);
    }
  }

  @override
  void initState() {
    _getAdminUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _userModel = Provider.of<UserModelProvider>(context).userModel!;
    return Material(
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: ColorsConts.primaryColor),
            elevation: 0,
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            foregroundColor: ColorsConts.primaryColor,
            title: Text(I18NTranslations.of(context).text('permission_setting'))),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      width: _size.width,
      height: _size.height,
      color: Colors.white,
      child: Column(
        children: [
          _inputWidget(),
          const SizedBox(height: 20),
          _listUser(),
        ],
      ),
    );
  }

  Widget _inputWidget() {
    return Column(children: [
      _textInputWidget(),
      Row(
        children: [
          Expanded(child: _settingButton(true)),
          Expanded(child: _settingButton(false)),
        ],
      ),
    ]);
  }

  Widget _listUser() {
    return Expanded(
      child: Container(
        width: _size.width,
        height: _size.height,
        color: const Color.fromRGBO(250, 250, 250, 1),
        child: SingleChildScrollView(
          child: _adminUserList.isEmpty
              ? Container()
              : Column(
                  children: List.generate(_adminUserList.length, (index) => _item(_adminUserList[index])),
                ),
        ),
      ),
    );
  }

  Widget _item(UserModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.name),
              Text(model.phone),
            ],
          ),
          CustomeAnimatedButton(
            hegith: 40,
            radius: 10,
            title: I18NTranslations.of(context).text('disqualification'),
            onTap: () => _onDeleteRole(model.phone),
            isShowShadow: false,
            backgroundColor: Colors.red,
          )
        ],
      ),
    );
  }

  Widget _settingButton(bool isSuperAdmin) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomeAnimatedButton(
        hegith: 50,
        title: I18NTranslations.of(context).text(isSuperAdmin ? 'set_to_super_admin' : 'set_to_admin'),
        onTap: () {
          if (_editingController.text != _userModel.phone) {
            _onAddRole(isSuperAdmin);
          } else {
            DialogWidget.show(context, I18NTranslations.of(context).text('phone_already_admin'), dialogType: DialogType.WARNING);
          }
        },
        isShowShadow: true,
        backgroundColor: isSuperAdmin ? Colors.green : Colors.blue,
      ),
    );
  }

  Widget _textInputWidget() {
    return Container(
      margin: const EdgeInsets.all(20),
      width: _size.width,
      height: 60,
      child: TextField(
        controller: _editingController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: I18NTranslations.of(context).text('phone_number'),
          label: Text(I18NTranslations.of(context).text('phone_number')),
          prefixIcon: const Icon(Icons.phone),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
