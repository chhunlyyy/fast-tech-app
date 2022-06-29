import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/const/enum.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/screens/components/product_component/product_item.dart';
import 'package:fast_tech_app/screens/list_camera_screen/list_camera_screen.dart';
import 'package:fast_tech_app/services/product_service/product_service.dart';
import 'package:fast_tech_app/widget/animation.dart';
import 'package:fast_tech_app/widget/circular_container.dart';
import 'package:fast_tech_app/widget/emtpy_data_widget.dart';
import 'package:fast_tech_app/widget/grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class ListProductScreen extends StatefulWidget {
  final bool isElectronicDevice;
  const ListProductScreen({Key? key, required this.isElectronicDevice}) : super(key: key);

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> with TickerProviderStateMixin {
  late bool _isElectronic;
  late Size _size;
  late TabController _tabController;

  List<ProductModel> _productModelList = [];
  LoadingStatusEnum _loadingStatusEnum = LoadingStatusEnum.loading;
  int _pageIndex = 0;

  int _tabIndex = 0;
  final int _pageSize = 10;

  void _getAllProducts(bool isRefresh, {int isMinQtyOne = 1}) {
    try {
      _pageIndex = isRefresh ? 0 : _pageIndex + 1;
      //
      Future.delayed(Duration.zero, () async {
        await productService
            .getAllProduct(
          isMinQtyOne: isMinQtyOne,
          pageSize: _pageSize,
          pageIndex: _pageIndex,
          isGetCameraProduct: _isElectronic ? 0 : 1,
          isGetElectronicProduct: _isElectronic ? 1 : 0,
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
    _tabController = TabController(length: 2, vsync: this);
    _isElectronic = widget.isElectronicDevice;
    _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: ColorsConts.primaryColor),
          elevation: 0,
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          foregroundColor: ColorsConts.primaryColor,
          title: Text(I18NTranslations.of(context).text(_isElectronic ? 'electronic_device' : 'camera_device'))),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return EasyRefresh(
      header: BezierHourGlassHeader(backgroundColor: ColorsConts.primaryColor, color: Colors.white),
      onLoad: (() async {
        _getAllProducts(false, isMinQtyOne: _tabIndex == 0 ? 1 : 0);
      }),
      onRefresh: () {
        return Future.delayed(Duration.zero, (() {
          _getAllProducts(true, isMinQtyOne: _tabIndex == 0 ? 1 : 0);
        }));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            key: UniqueKey(),
            child: !_isElectronic ? _orderAsPackageIcon() : const SizedBox.shrink(),
          ),
          SliverAppBar(
            forceElevated: true,
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            elevation: 1,
            automaticallyImplyLeading: false,
            pinned: true,
            floating: true,
            title: TabBar(
              indicatorColor: Colors.transparent,
              onTap: (index) {
                Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
                  setState(() {
                    _tabIndex = index;
                    _getAllProducts(true, isMinQtyOne: index == 0 ? 1 : 0);
                  });
                });
              },
              controller: _tabController,
              tabs: [
                _buildTabTitle(true, 0),
                _buildTabTitle(false, 1),
              ],
            ),
          ),
          SliverFillRemaining(
              child: TabBarView(controller: _tabController, children: [
            _listAllProductWidget(),
            _listAllProductWidget(),
          ])),
        ],
      ),
    );
  }

  Widget _buildTabTitle(bool isFirst, int index) {
    return Center(
      child: Column(
        children: [
          Text(
            I18NTranslations.of(context).text(isFirst ? 'minimum_one' : 'minimum_greater_1'),
            style: TextStyle(color: _tabIndex == index ? ColorsConts.primaryColor : Colors.grey),
          ),
          Container(height: 1, color: _tabIndex == index ? ColorsConts.primaryColor : Colors.transparent),
        ],
      ),
    );
  }

  Widget _orderAsPackageIcon() {
    return ClipRRect(
      child: Container(
        width: _size.width,
        height: 120,
        decoration: BoxDecoration(color: ColorsConts.primaryColor),
        child: Stack(
          children: [
            Positioned(top: 60, right: -150, child: CircularContainer.circularContainer(300, const Color(0xFFFAEACB).withOpacity(.35))),
            Positioned(top: -140, left: -120, child: CircularContainer.circularContainer(_size.width * .5, const Color(0xFFFAEACB).withOpacity(.45))),
            Positioned(
              top: -200,
              right: -45,
              child: CircularContainer.circularContainer(_size.width * .6, Colors.transparent, borderColor: Colors.white38),
            ),
            Center(
              child: Text(
                I18NTranslations.of(context).text('order_as_package'),
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => NavigationHelper.push(context, const ListCameraScreen()),
              ),
            )
          ],
        ),
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
