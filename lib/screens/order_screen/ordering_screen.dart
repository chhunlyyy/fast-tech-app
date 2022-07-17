import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:fast_tech_app/core/models/delivery_order_model.dart';
import 'package:fast_tech_app/core/models/package_order_model.dart';
import 'package:fast_tech_app/core/models/pickup_order_model.dart';
import 'package:fast_tech_app/core/provider/delivery_order_provider.dart';
import 'package:fast_tech_app/core/provider/package_order_provider.dart';
import 'package:fast_tech_app/core/provider/pickup_order_provider.dart';
import 'package:fast_tech_app/core/provider/user_model_provider.dart';
import 'package:fast_tech_app/core/provider/user_role_provider.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/helper/order_status_helper.dart';
import 'package:fast_tech_app/screens/map_screen/map_screen.dart';
import 'package:fast_tech_app/screens/ordering_stepper_screen/ordering_stepper_screen.dart';
import 'package:fast_tech_app/services/order_service/order_service.dart';
import 'package:fast_tech_app/widget/animation.dart';
import 'package:fast_tech_app/widget/change_status_bottom_sheet.dart';
import 'package:fast_tech_app/widget/empty_widget.dart';
import 'package:fast_tech_app/widget/show_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class OrderingScreen extends StatefulWidget {
  final int index;
  const OrderingScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<OrderingScreen> createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  late Size _size;
  List<PickupOrderModel> _pickupOrderModelList = [];
  List<DeliveryOrderModel> _deliveryOrderModelList = [];
  List<PackageOrderModel> _packageOrderModelList = [];
  int _statusIndex = 0;

  void getPackageOrder(int userId) {
    Future.delayed(Duration.zero, () async {
      await orderService.getPackageOrder(userId).then((value) {
        Provider.of<PackageOrderModelProvider>(context, listen: false).setPackageupOrderModel(value);
      });
    });
  }

  void getPickupOrder(int userId) {
    Future.delayed(Duration.zero, () async {
      await orderService.getPickupOrder(userId).then((value) {
        Provider.of<PickupOrderModelProvider>(context, listen: false).setPickupOrderModel(value);
      });
    });
  }

  void getDeliveryOrder(int userId) {
    Future.delayed(Duration.zero, () async {
      await orderService.getDeliveryOrder(userId).then((value) {
        Provider.of<DeliveryOrderModelProvider>(context, listen: false).setDeliveryModel(value);
      });
    });
  }

  void _getData() {
    int userId = Provider.of<UserModelProvider>(context, listen: false).userModel!.id;
    getPickupOrder(userId);
    getDeliveryOrder(userId);
    getPackageOrder(userId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _statusIndex = widget.index;
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _pickupOrderModelList = Provider.of<PickupOrderModelProvider>(context).pickupOrderModelList;
    _deliveryOrderModelList = Provider.of<DeliveryOrderModelProvider>(context).deliveryOrderModelList;
    _packageOrderModelList = Provider.of<PackageOrderModelProvider>(context).packageOrderModelList;
    return Material(
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: ColorsConts.primaryColor),
            elevation: 0,
            backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
            foregroundColor: ColorsConts.primaryColor,
            title: Text(I18NTranslations.of(context).text('is_buying'))),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    late Widget content;
    if (_statusIndex == 0) {
      content = _deliveryOrderModelList.isEmpty ? emptyWidget(context: context) : _listDeliveryOrderWidget();
    } else if (_statusIndex == 1) {
      content = _pickupOrderModelList.isEmpty ? emptyWidget(context: context) : _listPickupOrderWidget();
    } else {
      content = _packageOrderModelList.isEmpty ? emptyWidget(context: context) : _listPackageOrderWidget();
    }
    return SizedBox(
      width: _size.width,
      height: _size.height,
      child: Column(
        children: [
          _switchStatusBarWidget(),
          content,
        ],
      ),
    );
  }

  Widget _listPackageOrderWidget() {
    return Expanded(
      child: EasyRefresh(
        header: BezierHourGlassHeader(backgroundColor: ColorsConts.primaryColor, color: Colors.white),
        onRefresh: () {
          return Future.delayed(Duration.zero, (() {
            _getData();
          }));
        },
        child: Column(
          children: List.generate(_packageOrderModelList.length, (index) => AnimationWidget.animation(index, _orderItem(_packageOrderModelList[index], true, false))),
        ),
      ),
    );
  }

  Widget _listDeliveryOrderWidget() {
    return Expanded(
      child: EasyRefresh(
        header: BezierHourGlassHeader(backgroundColor: ColorsConts.primaryColor, color: Colors.white),
        onRefresh: () {
          return Future.delayed(Duration.zero, (() {
            _getData();
          }));
        },
        child: Column(
          children: List.generate(_deliveryOrderModelList.length, (index) => AnimationWidget.animation(index, _orderItem(_deliveryOrderModelList[index], false, false))),
        ),
      ),
    );
  }

  Widget _listPickupOrderWidget() {
    return Expanded(
      child: EasyRefresh(
        header: BezierHourGlassHeader(backgroundColor: ColorsConts.primaryColor, color: Colors.white),
        onRefresh: () {
          return Future.delayed(Duration.zero, (() {
            _getData();
          }));
        },
        child: Column(
          children: List.generate(_pickupOrderModelList.length, (index) => AnimationWidget.animation(index, _orderItem(_pickupOrderModelList[index], false, true))),
        ),
      ),
    );
  }

  Widget _switchStatusBarWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: _size.width,
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.withOpacity(.2)), boxShadow: [
        BoxShadow(
          blurRadius: 2,
          spreadRadius: 2,
          color: Colors.grey.withOpacity(.5),
        ),
      ]),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _statusItem(0),
            _statusItem(1),
            _statusItem(2),
          ],
        ),
      ),
    );
  }

  Widget _statusItem(int index) {
    late String text;
    late String qty;
    if (index == 0) {
      text = I18NTranslations.of(context).text('delivery');
      qty = _deliveryOrderModelList.length.toString();
    } else if (index == 1) {
      text = I18NTranslations.of(context).text('pick_up');
      qty = _pickupOrderModelList.length.toString();
    } else {
      text = I18NTranslations.of(context).text('package_order');
      qty = _packageOrderModelList.length.toString();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _statusIndex == index ? Colors.grey.withOpacity(.1) : Colors.white,
        borderRadius: BorderRadius.circular(1000),
        border: Border.all(color: _statusIndex == index ? Colors.blue : Colors.transparent),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _statusIndex = index;
              });
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      text,
                      style: TextStyle(color: _statusIndex == index ? Colors.blue : Colors.black),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                      child: Text(
                        qty,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _orderItem(var model, bool isPackageOrder, bool isPickupOrder) {
    return InkWell(
      onTap: () {
        (Provider.of<UserRoleProvider>(context, listen: false).isAdmin || Provider.of<UserRoleProvider>(context, listen: false).isSuperAdmin)
            ? ChangeOrderStatusBottomSheet.show(context, model, isPackage: isPackageOrder, isPickUp: isPickupOrder)
            : NavigationHelper.push(
                context,
                OrderingStepperScreen(
                  orderModel: model,
                  isPackage: isPackageOrder,
                  isPickup: isPickupOrder,
                ));
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _displayImageWidget(model),
              _displayNameWidget(model, isPackageOrder),
              !isPackageOrder ? _displayPriceWidget(model, (isPickupOrder == false)) : _deliveryIconWidget(model),
            ]),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              color: OrderStatusHelper.getColor(model.status),
              child: Text(
                I18NTranslations.of(context).text(OrderStatusHelper.getDesc(model.status)),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _displayPriceWidget(var model, bool isDelivery) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(I18NTranslations.of(context).text('qty') + '\t' + model.qty.toString()),
        Text(
          r'$' + (model.product.priceAfterDiscount * model.qty).toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ColorsConts.primaryColor),
        ),
        (isDelivery && (Provider.of<UserRoleProvider>(context).isAdmin || Provider.of<UserRoleProvider>(context).isSuperAdmin)) ? _deliveryIconWidget(model) : const SizedBox.shrink()
      ],
    );
  }

  Widget _deliveryIconWidget(var model) {
    return InkWell(
      onTap: () {
        NavigationHelper.push(
          context,
          MapScreen(
            direction: LatLng(double.parse(model.product.address[0].latitude), double.parse(model.product.address[0].longitude)),
          ),
        );
      },
      child: const Icon(
        Icons.delivery_dining,
        color: Colors.blue,
        size: 30,
      ),
    );
  }

  Widget _displayNameWidget(var model, bool isPackageOrder) {
    return Column(
      children: [
        Text(model.product.name),
        !isPackageOrder
            ? Text(
                I18NTranslations.of(context).text('color') + '\t' + model.product.colors[0].color,
                style: const TextStyle(color: Colors.grey),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _displayImageWidget(var model) {
    return SizedBox(
      width: 100,
      height: 100,
      child: DisplayImage(
        imageString: model.product.images[0].image,
        imageBorderRadius: 5,
        boxFit: BoxFit.cover,
      ),
    );
  }
}
