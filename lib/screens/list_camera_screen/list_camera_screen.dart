import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/const/enum.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/screens/components/product_component/product_detail.dart';
import 'package:fast_tech_app/screens/map_screen/user_map.dart';
import 'package:fast_tech_app/screens/order_screen/ordering_screen.dart';
import 'package:fast_tech_app/services/order_service/order_service.dart';
import 'package:fast_tech_app/services/product_service/product_service.dart';
import 'package:fast_tech_app/widget/dialog_widget.dart';
import 'package:fast_tech_app/widget/show_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ListCameraScreen extends StatefulWidget {
  const ListCameraScreen({Key? key}) : super(key: key);

  @override
  State<ListCameraScreen> createState() => _ListCameraScreenState();
}

class _ListCameraScreenState extends State<ListCameraScreen> {
  int _pageIndex = 0;
  final int _pageSize = 10;
  LoadingStatusEnum _loadingStatusEnum = LoadingStatusEnum.loading;
  List<ProductModel> _productModelList = [];

  void _getAllProducts(bool isRefresh) {
    try {
      _pageIndex = isRefresh ? 0 : _pageIndex + 1;
      //
      Future.delayed(Duration.zero, () async {
        await productService
            .getAllCamera(
          pageSize: _pageSize,
          pageIndex: _pageIndex,
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

  void _onAddPackageOrder(ProductModel productModel, LatLng location) {
    Map<String, dynamic> params = {
      'user_id': Provider.of<UserModelProvider>(context, listen: false).userModel!.id,
      'product_id': productModel.id,
      'address_id_ref': const Uuid().v4(),
      'status': '0',
      'latitude': location.latitude,
      'longitude': location.longitude,
    };

    orderService.packageOrder(params).then((value) {
      if (value == '200') {
        DialogWidget.show(context, I18NTranslations.of(context).text('order_success'), dialogType: DialogType.SUCCES);
        Future.delayed(const Duration(seconds: 2)).whenComplete(() {
          Navigator.pop(context);
          Navigator.pop(context);
          NavigationHelper.push(
              context,
              const OrderingScreen(
                index: 2,
              ));
        });
      } else {
        DialogWidget.show(context, I18NTranslations.of(context).text('order_error'), dialogType: DialogType.ERROR);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: ColorsConts.primaryColor),
          elevation: 0,
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          foregroundColor: ColorsConts.primaryColor,
          title: Text(I18NTranslations.of(context).text('plz_pick_camera'))),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _loadingStatusEnum != LoadingStatusEnum.done ? Container() : _listCameraWidget();
  }

  Widget _listCameraWidget() {
    return EasyRefresh(
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
          children: List.generate(
            _productModelList.length,
            (index) => _cameraListItem(_productModelList[index]),
          ),
        ));
  }

  Widget _cameraListItem(ProductModel productModel) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                NavigationHelper.push(context, UserMapScreen(
                  location: ((location) {
                    _onAddPackageOrder(productModel, location);
                  }),
                ));
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: DisplayImage(boxFit: BoxFit.cover, imageString: productModel.images[0].image, imageBorderRadius: 10),
                  ),
                  Expanded(child: Center(child: Text(productModel.name))),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => NavigationHelper.push(context, ProductDetail(productModel: productModel)),
            child: Text(
              I18NTranslations.of(context).text('see_detail'),
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
