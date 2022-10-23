import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/const/enum.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/screens/components/product_component/product_item.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen.dart';
import 'package:fast_tech_app/services/product_service/product_service.dart';
import 'package:fast_tech_app/widget/animation.dart';
import 'package:fast_tech_app/widget/emtpy_data_widget.dart';
import 'package:fast_tech_app/widget/grid_view.dart';
import 'package:fast_tech_app/widget/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class SearchScreen extends StatefulWidget {
  final TextEditingController textEditingController;
  final TextEditingController startPriceConttroller;
  final TextEditingController toPriceController;
  const SearchScreen({Key? key, required this.textEditingController, required this.startPriceConttroller, required this.toPriceController}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Size _size;
  LoadingStatusEnum _loadingStatusEnum = LoadingStatusEnum.loading;
  List<ProductModel> _productModelList = [];

  int _pageIndex = 0;
  final int _pageSize = 10;

  void _getAllProducts(bool isRefresh) {
    try {
      _pageIndex = isRefresh ? 0 : _pageIndex + 1;
      //
      Future.delayed(Duration.zero, () async {
        await productService
            .search(
          pageSize: _pageSize,
          pageIndex: _pageIndex,
          productName: widget.textEditingController.text,
          toPrice: widget.toPriceController.text,
          startPrice: widget.startPriceConttroller.text,
        )
            .then((value) {
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
    // TODO: implement initState
    super.initState();
    _getAllProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      width: _size.width,
      height: _size.height,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: (() {
                    NavigationHelper.pushReplacement(
                        context,
                        const HomeScreen(
                          dasboardEnum: DASBOARD_ENUM.homeScreen,
                        ));
                  }),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: ColorsConts.primaryColor,
                    size: 30,
                  ),
                ),
              ),
              Expanded(
                  child: SearchWidget.searchWidget(
                context,
                () {
                  _getAllProducts(true);
                },
                widget.textEditingController,
                widget.startPriceConttroller,
                widget.toPriceController,
              )),
            ],
          ),
          Expanded(
              child: EasyRefresh(
            header: BezierHourGlassHeader(backgroundColor: ColorsConts.primaryColor, color: Colors.white),
            onLoad: (() async {
              _getAllProducts(false);
            }),
            onRefresh: () {
              return Future.delayed(Duration.zero, (() {
                _getAllProducts(true);
              }));
            },
            child: _listAllProductWidget(),
          ))
        ],
      ),
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
}
