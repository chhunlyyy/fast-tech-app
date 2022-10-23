import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/const/enum.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/screens/components/product_component/product_item.dart';
import 'package:fast_tech_app/screens/list_product_screen/list_prodcut_screen.dart';
import 'package:fast_tech_app/screens/search_screen/search_screen.dart';
import 'package:fast_tech_app/services/product_service/product_service.dart';
import 'package:fast_tech_app/widget/animation.dart';
import 'package:fast_tech_app/widget/emtpy_data_widget.dart';
import 'package:fast_tech_app/widget/grid_view.dart';
import 'package:fast_tech_app/widget/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../const/color_conts.dart';

class HomeScreenDashboardComponents extends StatefulWidget {
  const HomeScreenDashboardComponents({Key? key}) : super(key: key);

  @override
  State<HomeScreenDashboardComponents> createState() => _HomeScreenDashboardComponentsState();
}

class _HomeScreenDashboardComponentsState extends State<HomeScreenDashboardComponents> {
  late Size _size;
  List<ProductModel> _productModelList = [];
  LoadingStatusEnum _loadingStatusEnum = LoadingStatusEnum.loading;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _startPriceController = TextEditingController();
  final TextEditingController _toPriceController = TextEditingController();
  int _pageIndex = 0;
  final int _pageSize = 10;

  void _getAllProducts(bool isRefresh) {
    try {
      _pageIndex = isRefresh ? 0 : _pageIndex + 1;
      //
      Future.delayed(Duration.zero, () async {
        await productService.getAllProduct(pageSize: _pageSize, pageIndex: _pageIndex).then((value) {
          setState(() {
            if (isRefresh) {
              _loadingStatusEnum = LoadingStatusEnum.loading;
              _productModelList.clear();
              _productModelList = value;
            } else {
              _productModelList.addAll(value);
            }
          });
        }).whenComplete(() {
          setState(() {
            _loadingStatusEnum = LoadingStatusEnum.done;
          });
        });
      });
    } catch (e) {
      _loadingStatusEnum = LoadingStatusEnum.error;
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Expanded(
      child: Material(
          child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: SizedBox(
                child: Column(children: [
                  SearchWidget.searchWidget(
                    context,
                    () {
                      if (_textEditingController.text.isNotEmpty || _toPriceController.text.isNotEmpty || _startPriceController.text.isNotEmpty) {
                        NavigationHelper.push(
                            context,
                            SearchScreen(
                              textEditingController: _textEditingController,
                              startPriceConttroller: _startPriceController,
                              toPriceController: _toPriceController,
                            ));
                      }
                    },
                    _textEditingController,
                    _startPriceController,
                    _toPriceController,
                  ),
                  _textLabel(false),
                  _productTypeWidget(),
                ]),
              ),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 40,
              backgroundColor: const Color(0xffFAF9FE),
              pinned: true,
              title: Container(margin: const EdgeInsets.only(bottom: 15), alignment: Alignment.centerLeft, child: _textLabel(true)),
            ),
          ];
        },
        body: EasyRefresh(
            header: BezierHourGlassHeader(backgroundColor: ColorsConts.primaryColor, color: Colors.white),
            onLoad: (() async {
              _getAllProducts(false);
            }),
            onRefresh: () {
              return Future.delayed(Duration.zero, (() {
                _getAllProducts(true);
              }));
            },
            child: Column(
              children: [
                _listAllProductWidget(),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                )
              ],
            )),
      )),
    );
  }

  Widget _listAllProductWidget() {
    Widget content = Container();
    if (_productModelList.isNotEmpty) {
      setState(() {
        content = GridViewWidget.gridView(
            context: context,
            children: List<Widget>.generate(_productModelList.length, (index) {
              return GridTile(
                  child: AnimationWidget.animation(
                      index,
                      ProductItem(
                        productModel: _productModelList[index],
                      )));
            }));
      });
    } else if (_loadingStatusEnum == LoadingStatusEnum.done || _loadingStatusEnum == LoadingStatusEnum.error) {
      setState(() {
        content = EmptyDataWidget.emptyDataWidget(context);
      });
    }

    return content;
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
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isElectronic ? Colors.blue : Colors.black,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  NavigationHelper.push(
                      context,
                      ListProductScreen(
                        isElectronicDevice: isElectronic,
                      ));
                },
                child: Center(
                  child: Text(
                    I18NTranslations.of(context).text(isElectronic ? 'electronic_device' : 'camera_device'),
                    style: TextStyle(color: isElectronic ? Colors.blue : Colors.black),
                  ),
                ),
              ),
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
}
