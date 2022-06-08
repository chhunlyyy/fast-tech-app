import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/widget/custome_animated_button.dart';
import 'package:flutter/material.dart';

import '../../../const/color_conts.dart';

class HomeScreenDashboardComponents extends StatefulWidget {
  const HomeScreenDashboardComponents({Key? key}) : super(key: key);

  @override
  State<HomeScreenDashboardComponents> createState() => _HomeScreenDashboardComponentsState();
}

class _HomeScreenDashboardComponentsState extends State<HomeScreenDashboardComponents> {
  late Size _size;
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _searchWidget(),
            _textLabel(false),
            _productTypeWidget(),
            _textLabel(true),
            SizedBox(height: _size.height / 9 + 20),
          ],
        ),
      ),
    );
  }

  Widget _productTypeWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          _buildProductTypeButton(true),
          const SizedBox(width: 10),
          _buildProductTypeButton(false),
        ],
      ),
    );
  }

  Widget _buildProductTypeButton(bool isElectronic) {
    return Expanded(
        child: Stack(
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isElectronic ? Colors.blue : Colors.black,
            ),
          ),
          child: Center(
            child: Text(
              I18NTranslations.of(context).text(isElectronic ? 'electronic_device' : 'camera_device'),
              style: TextStyle(color: isElectronic ? Colors.blue : Colors.black),
            ),
          ),
        ),
        Positioned(width: 50, height: 50, top: 0, right: 0, child: Image.asset(isElectronic ? AssetsConst.ELECTRONIC_ICON : AssetsConst.CAMERA_ICON)),
      ],
    ));
  }

  Widget _textLabel(bool isAllProducts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            I18NTranslations.of(context).text(isAllProducts ? 'all_products' : 'product_type'),
            style: TextStyle(color: ColorsConts.primaryColor, fontSize: 16),
          ),
        ),
        Container(
          width: _size.width,
          height: 2,
          color: Colors.white,
        )
      ],
    );
  }

  Widget _searchWidget() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1000),
              border: Border.all(
                color: Colors.grey.withOpacity(.2),
              ),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.black,
                  ),
                  hintText: I18NTranslations.of(context).text('search')),
            ),
          ),
        ),
        CustomeAnimatedButton(
          title: I18NTranslations.of(context).text('search'),
          onTap: () {},
          isShowShadow: true,
          width: 100,
          hegith: 40,
          backgroundColor: Colors.blue,
          radius: 10,
        ),
        const SizedBox(width: 5),
      ],
    );
  }
}
