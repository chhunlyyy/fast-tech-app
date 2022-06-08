import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
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
            _textTypeLabel(),
            _productTypeWidget(),
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
          Expanded(
              child: Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),
                child: Center(
                  child: Text(
                    I18NTranslations.of(context).text('electronic_device'),
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              Positioned(width: 50, height: 50, top: 0, right: 0, child: Image.asset(AssetsConst.ELECTRONIC_ICON)),
            ],
          )),
          const SizedBox(width: 10),
          Expanded(
              child: Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Center(
                  child: Text(
                    I18NTranslations.of(context).text('camera_device'),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Positioned(width: 50, height: 50, top: 0, right: 0, child: Image.asset(AssetsConst.CAMERA_ICON)),
            ],
          )),
        ],
      ),
    );
  }

  Widget _textTypeLabel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            I18NTranslations.of(context).text('product_type'),
            style: TextStyle(color: ColorsConts.primaryColor, fontSize: 20),
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
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      width: _size.width,
      height: 75,
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
    );
  }
}
